import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Общий чат: сообщения из Firestore `messages` в реальном времени.
class CommunityMessagesPanel extends StatefulWidget {
  /// Если true — не дублировать заголовок (родитель уже показал).
  final bool skipOuterTitle;

  const CommunityMessagesPanel({super.key, this.skipOuterTitle = false});

  @override
  State<CommunityMessagesPanel> createState() => _CommunityMessagesPanelState();
}

class _CommunityMessagesPanelState extends State<CommunityMessagesPanel> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(150)
        .snapshots();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Войдите в аккаунт, чтобы отправить сообщение'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': text,
        'senderId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _textController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось отправить: $e'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.skipOuterTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Общий чат сообщества',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _messagesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Ошибка: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white54));
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Пока нет сообщений.\nВойдите и напишите первым.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.4),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final d = doc.data();
                      final text = d['text'] as String? ?? '';
                      final senderId = d['senderId'] as String? ?? '';
                      final isMe = uid != null && senderId == uid;
                      final label = senderId.length <= 10 ? senderId : '${senderId.substring(0, 8)}…';
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.78,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF6A63FF).withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isMe && senderId.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.45),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              Text(
                                text,
                                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Сообщение...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF6A63FF), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _send,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A63FF),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Отправить', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
