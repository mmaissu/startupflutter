import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Парный проект в разделе «Дуо проекты»
class DuoProject {
  final String id;
  final String title;
  final String type;
  final String shortDescription;
  final String fullDescription;

  /// Срок завершения (дата без времени логически)
  final DateTime deadline;

  /// Сколько человек нужно в команде всего
  final int teamSizeTarget;

  /// Участники проекта (uid). Это поле используется для присоединения через Firestore.
  final List<String> memberUids;

  /// Уже в команде (имена для отображения)
  final List<String> participantNames;

  /// Обложка (в памяти; из Firestore — из base64)
  final Uint8List? coverImageBytes;

  /// Автор (Firebase Auth uid), если есть
  final String? creatorUid;

  const DuoProject({
    required this.id,
    required this.title,
    required this.type,
    required this.shortDescription,
    required this.fullDescription,
    required this.deadline,
    required this.teamSizeTarget,
    required this.memberUids,
    required this.participantNames,
    this.coverImageBytes,
    this.creatorUid,
  });

  /// Поля для записи в Firestore (без служебных FieldValue — их добавляет сервис)
  Map<String, dynamic> toFirestorePayload() {
    return {
      'title': title,
      'type': type,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'deadline': Timestamp.fromDate(deadline),
      'teamSizeTarget': teamSizeTarget,
      'members': memberUids,
      'participantNames': participantNames,
      if (creatorUid != null && creatorUid!.isNotEmpty) 'creatorUid': creatorUid,
    };
  }

  factory DuoProject.fromFirestoreDocument(String id, Map<String, dynamic> data) {
    DateTime deadline;
    final rawD = data['deadline'];
    if (rawD is Timestamp) {
      deadline = rawD.toDate();
    } else if (rawD is int) {
      deadline = DateTime.fromMillisecondsSinceEpoch(rawD);
    } else {
      deadline = DateTime.now();
    }

    final namesRaw = data['participantNames'];
    final names = namesRaw is List
        ? namesRaw.map((e) => e.toString()).toList()
        : <String>['Участник'];

    final membersRaw = data['members'];
    final members = membersRaw is List ? membersRaw.map((e) => e.toString()).toList() : <String>[];

    Uint8List? cover;
    final b64 = data['coverImageBase64'];
    if (b64 is String && b64.isNotEmpty) {
      try {
        cover = Uint8List.fromList(base64Decode(b64));
      } catch (_) {}
    }

    return DuoProject(
      id: id,
      title: data['title'] as String? ?? '',
      type: data['type'] as String? ?? 'Проект',
      shortDescription: data['shortDescription'] as String? ?? '',
      fullDescription: data['fullDescription'] as String? ?? '',
      deadline: deadline,
      teamSizeTarget: (data['teamSizeTarget'] as num?)?.toInt() ?? 2,
      memberUids: members,
      participantNames: names,
      coverImageBytes: cover,
      creatorUid: data['creatorUid'] as String?,
    );
  }

  int get currentMemberCount => memberUids.isNotEmpty ? memberUids.length : participantNames.length;

  /// Сколько мест осталось набрать
  int get slotsOpen {
    final n = teamSizeTarget - currentMemberCount;
    return n < 0 ? 0 : n;
  }

  /// Дедлайн в ближайшие 7 дней (включая сегодня)
  bool get isUrgent {
    final days = _daysUntilDeadline;
    return days >= 0 && days <= 7;
  }

  /// Очень близкий дедлайн — 0–3 дня
  bool get isCritical {
    final days = _daysUntilDeadline;
    return days >= 0 && days <= 3;
  }

  int get _daysUntilDeadline {
    final now = DateTime.now();
    final d = DateTime(deadline.year, deadline.month, deadline.day);
    final today = DateTime(now.year, now.month, now.day);
    return d.difference(today).inDays;
  }

  String get deadlineLabel {
    final days = _daysUntilDeadline;
    if (days < 0) return 'Срок прошёл';
    if (days == 0) return 'Сегодня';
    if (days == 1) return 'Завтра';
    return 'Через $days дн.';
  }
}
