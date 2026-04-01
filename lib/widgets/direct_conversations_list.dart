import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/direct_chat_screen.dart';
import '../services/user_directory_service.dart';

/// Список личных диалогов — чтобы входящие были видны без поиска собеседника.
class DirectConversationsList extends StatelessWidget {
  const DirectConversationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('directChats')
          .where('participantIds', arrayContains: uid)
          .snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Не удалось загрузить диалоги: ${snap.error}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          );
        }
        if (snap.connectionState == ConnectionState.waiting && snap.data == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54))),
          );
        }
        final raw = snap.data?.docs ?? [];
        final docs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(raw);
        docs.sort((a, b) {
          final ta = a.data()['updatedAt'] as Timestamp?;
          final tb = b.data()['updatedAt'] as Timestamp?;
          if (ta == null && tb == null) return 0;
          if (ta == null) return 1;
          if (tb == null) return -1;
          return tb.compareTo(ta);
        });

        if (docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Личных сообщений пока нет. Когда кто-то напишет тебе в личку, диалог появится здесь. Общий чат — ниже.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12, height: 1.35),
            ),
          );
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: Material(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: docs.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              itemBuilder: (context, i) {
                final doc = docs[i];
                final chatId = doc.id;
                final peerUid = UserDirectoryService.peerUidFromChatId(chatId, uid);
                if (peerUid == null) return const SizedBox.shrink();
                final last = doc.data()['lastMessageText'] as String? ?? '';

                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('users').doc(peerUid).snapshots(),
                  builder: (context, userSnap) {
                    final name = userSnap.data?.data()?['displayName'] as String? ?? 'Пользователь';
                    return ListTile(
                      dense: true,
                      title: Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Text(
                        last.isEmpty ? 'Написать…' : last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 22),
                      onTap: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => DirectChatScreen(
                              peerUid: peerUid,
                              peerDisplayName: name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
