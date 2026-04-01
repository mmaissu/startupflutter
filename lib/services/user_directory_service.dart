import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Публичные поля в `users/{uid}` для поиска и отображения.
class UserSearchHit {
  final String uid;
  final String displayName;
  final String? email;

  const UserSearchHit({
    required this.uid,
    required this.displayName,
    this.email,
  });

  factory UserSearchHit.fromDoc(String id, Map<String, dynamic> data) {
    return UserSearchHit(
      uid: id,
      displayName: data['displayName'] as String? ?? 'Пользователь',
      email: data['email'] as String?,
    );
  }
}

class UserDirectoryService {
  UserDirectoryService._();
  static final UserDirectoryService instance = UserDirectoryService._();

  final _firestore = FirebaseFirestore.instance;

  /// Стабильный id диалога 1:1 между двумя uid.
  static String directChatId(String uidA, String uidB) {
    final a = uidA.compareTo(uidB) < 0 ? uidA : uidB;
    final b = uidA.compareTo(uidB) < 0 ? uidB : uidA;
    return '${a}_$b';
  }

  /// Второй участник из id чата `uidМеньший_uidБольший` (uid в Firebase без `_` внутри).
  static String? peerUidFromChatId(String chatId, String myUid) {
    final parts = chatId.split('_');
    if (parts.length != 2) return null;
    return parts[0] == myUid ? parts[1] : parts[0];
  }

  /// Записывает поля для поиска (merge — не затирает completedLessons и др.).
  Future<void> ensurePublicProfile(User user) async {
    final email = user.email ?? '';
    if (email.isEmpty) return;
    final local = email.split('@').first;
    final displayName = user.displayName?.trim().isNotEmpty == true ? user.displayName!.trim() : local;
    await _firestore.collection('users').doc(user.uid).set(
      {
        'email': email,
        'emailLower': email.toLowerCase(),
        'displayName': displayName,
        'displayNameLower': displayName.toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Поиск пользователей (минимум 2 символа).
  /// Сначала префикс по `emailLower` / `displayNameLower`, затем резервный обход
  /// документов (подстрока в email/имени) — иначе не находятся части вроде «gmail» или старые документы без полей *_lower.
  Future<List<UserSearchHit>> searchUsers(String query, {String? excludeUid}) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return [];

    final merged = <String, UserSearchHit>{};
    final col = _firestore.collection('users');

    void addDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
      if (excludeUid != null && d.id == excludeUid) return;
      merged[d.id] = UserSearchHit.fromDoc(d.id, d.data());
    }

    try {
      final byEmail = await col
          .where('emailLower', isGreaterThanOrEqualTo: q)
          .where('emailLower', isLessThanOrEqualTo: '$q\uf8ff')
          .limit(20)
          .get();
      for (final d in byEmail.docs) {
        addDoc(d);
      }

      final byName = await col
          .where('displayNameLower', isGreaterThanOrEqualTo: q)
          .where('displayNameLower', isLessThanOrEqualTo: '$q\uf8ff')
          .limit(20)
          .get();
      for (final d in byName.docs) {
        addDoc(d);
      }
    } catch (e, st) {
      debugPrint('UserDirectoryService.searchUsers prefix: $e\n$st');
    }

    /// Резерв: читаем ограниченный набор и ищем подстроку (нужны правила: read на users для авторизованных).
    try {
      final snap = await col.limit(200).get();
      for (final d in snap.docs) {
        if (excludeUid != null && d.id == excludeUid) continue;
        final data = d.data();
        final emailLower = (data['emailLower'] as String?) ?? (data['email'] as String? ?? '').toLowerCase();
        final nameLower = (data['displayNameLower'] as String?) ??
            (data['displayName'] as String? ?? '').toLowerCase();
        final local = emailLower.contains('@') ? emailLower.split('@').first : emailLower;
        final match = emailLower.contains(q) || nameLower.contains(q) || local.contains(q);
        if (match) {
          merged[d.id] = UserSearchHit.fromDoc(d.id, data);
        }
      }
    } catch (e, st) {
      debugPrint('UserDirectoryService.searchUsers scan: $e\n$st');
    }

    final list = merged.values.toList();
    list.sort((a, b) => a.displayName.compareTo(b.displayName));
    return list.take(25).toList();
  }
}
