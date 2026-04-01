import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Сохранение и загрузка прогресса уроков в Firestore: users/{uid}.completedLessons[courseId][lessonId]
class CourseProgressService {
  CourseProgressService._();
  static final CourseProgressService instance = CourseProgressService._();

  final _firestore = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Локальный кэш завершённых уроков (и для гостя, и как дополнение к Firestore при сбоях чтения).
  final Map<String, Map<String, bool>> _localFallback = {};

  static bool _asBool(dynamic v) {
    if (v == true) return true;
    if (v == false) return false;
    if (v is int) return v != 0;
    if (v is String) {
      final s = v.toLowerCase().trim();
      return s == 'true' || s == '1';
    }
    return false;
  }

  void _mergeLessonIntoCache(String courseId, String lessonId) {
    _localFallback.putIfAbsent(courseId, () => {});
    _localFallback[courseId]![lessonId] = true;
  }

  Map<String, bool> _mergeRemoteAndCache(String courseId, Map<String, bool> remote) {
    final cached = Map<String, bool>.from(_localFallback[courseId] ?? {});
    final allKeys = {...remote.keys, ...cached.keys};
    final merged = <String, bool>{};
    for (final k in allKeys) {
      merged[k] = (remote[k] == true) || (cached[k] == true);
    }
    _localFallback[courseId] = merged;
    return merged;
  }

  /// [forceServer] — после сохранения запросить свежие данные с сервера (меньше шансов увидеть устаревший кэш).
  Future<Map<String, bool>> loadCompletedLessons(String courseId, {bool forceServer = false}) async {
    final cachedOnly = Map<String, bool>.from(_localFallback[courseId] ?? {});
    final uid = _uid;
    if (uid == null) {
      return cachedOnly;
    }
    try {
      final doc = await _firestore.collection('users').doc(uid).get(
            GetOptions(
              source: forceServer ? Source.server : Source.serverAndCache,
            ),
          );
      final data = doc.data();
      final raw = data?['completedLessons'];
      if (raw is! Map) {
        return _mergeRemoteAndCache(courseId, {});
      }
      final courseRaw = raw[courseId];
      if (courseRaw is! Map) {
        return _mergeRemoteAndCache(courseId, {});
      }
      final remote = <String, bool>{};
      for (final e in courseRaw.entries) {
        remote[e.key.toString()] = _asBool(e.value);
      }
      return _mergeRemoteAndCache(courseId, remote);
    } catch (e, st) {
      debugPrint('CourseProgressService.loadCompletedLessons: $e\n$st');
      return cachedOnly;
    }
  }

  /// Возвращает false, если запись в Firestore не удалась (прогресс остаётся в локальном кэше).
  Future<bool> markLessonCompleted(String courseId, String lessonId) async {
    _mergeLessonIntoCache(courseId, lessonId);
    final uid = _uid;
    if (uid == null) {
      return true;
    }
    final docRef = _firestore.collection('users').doc(uid);
    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final data = snapshot.data() ?? <String, dynamic>{};
        final completedLessons = Map<String, dynamic>.from(data['completedLessons'] ?? {});
        final courseMap = Map<String, dynamic>.from(completedLessons[courseId] ?? {});
        courseMap[lessonId] = true;
        completedLessons[courseId] = courseMap;
        transaction.set(
          docRef,
          {
            'completedLessons': completedLessons,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      });
      return true;
    } catch (e, st) {
      debugPrint('CourseProgressService.markLessonCompleted: $e\n$st');
      return false;
    }
  }
}
