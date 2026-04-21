import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/duo_project.dart';

/// Хранение дуо-проектов: Firestore `duo_projects/{id}` и локальный кэш при сбоях / без входа.
class DuoProjectService {
  DuoProjectService._();
  static final DuoProjectService instance = DuoProjectService._();

  final _firestore = FirebaseFirestore.instance;

  /// Максимум сырого размера обложки для сохранения в документ (лимит Firestore ~1 МБ на поле).
  static const int _maxCoverBytes = 320000;

  final Map<String, DuoProject> _localFallback = {};

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<bool> updateProject(String projectId, Map<String, dynamic> updates) async {
    final uid = _uid;
    if (uid == null) return false;
    try {
      await _firestore.collection('duo_projects').doc(projectId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e, st) {
      debugPrint('DuoProjectService.updateProject: $e\n$st');
      return false;
    }
  }

  Future<bool> deleteProject(String projectId) async {
    final uid = _uid;
    if (uid == null) return false;
    try {
      await _firestore.collection('duo_projects').doc(projectId).delete();
      return true;
    } catch (e, st) {
      debugPrint('DuoProjectService.deleteProject: $e\n$st');
      return false;
    }
  }

  Future<bool> removeMember(String projectId, String memberUid) async {
    final uid = _uid;
    if (uid == null) return false;
    try {
      await _firestore.collection('duo_projects').doc(projectId).update({
        'members': FieldValue.arrayRemove([memberUid]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e, st) {
      debugPrint('DuoProjectService.removeMember: $e\n$st');
      return false;
    }
  }

  /// Присоединиться к дуо-проекту: добавляет uid в массив members.
  Future<bool> joinProject(String projectId) async {
    final uid = _uid;
    if (uid == null) return false;
    try {
      await _firestore.collection('duo_projects').doc(projectId).set(
        {
          'members': FieldValue.arrayUnion([uid]),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e, st) {
      debugPrint('DuoProjectService.joinProject: $e\n$st');
      return false;
    }
  }

  Future<List<DuoProject>> loadProjects() async {
    final localList = _localFallback.values.toList();
    if (_uid == null) {
      _sortByIdDesc(localList);
      return localList;
    }
    try {
      final snap = await _firestore.collection('duo_projects').get();
      final fromServer = snap.docs
          .map((d) => DuoProject.fromFirestoreDocument(d.id, d.data()))
          .toList();
      _sortByIdDesc(fromServer);
      final byId = {for (final p in fromServer) p.id: p};
      for (final p in localList) {
        byId.putIfAbsent(p.id, () => p);
      }
      final merged = byId.values.toList();
      _sortByIdDesc(merged);
      return merged;
    } catch (e, st) {
      debugPrint('DuoProjectService.loadProjects: $e\n$st');
      _sortByIdDesc(localList);
      return localList;
    }
  }

  void _sortByIdDesc(List<DuoProject> list) {
    list.sort((a, b) {
      final ai = int.tryParse(a.id) ?? 0;
      final bi = int.tryParse(b.id) ?? 0;
      return bi.compareTo(ai);
    });
  }

  /// Сохраняет проект. Возвращает false, если облако недоступно (данные остаются локально).
  Future<bool> saveProject(DuoProject project) async {
    final payload = Map<String, dynamic>.from(project.toFirestorePayload());
    payload['updatedAt'] = FieldValue.serverTimestamp();
    payload['createdAtMillis'] = int.tryParse(project.id) ?? DateTime.now().millisecondsSinceEpoch;

    final bytes = project.coverImageBytes;
    if (bytes != null && bytes.isNotEmpty && bytes.length <= _maxCoverBytes) {
      payload['coverImageBase64'] = base64Encode(bytes);
    }

    final uid = _uid;
    if (uid == null) {
      _localFallback[project.id] = project;
      return true;
    }

    try {
      await _firestore.collection('duo_projects').doc(project.id).set(
            payload,
            SetOptions(merge: true),
          );
      _localFallback[project.id] = project;
      return true;
    } catch (e, st) {
      debugPrint('DuoProjectService.saveProject: $e\n$st');
      _localFallback[project.id] = project;
      return false;
    }
  }
}
