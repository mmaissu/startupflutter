import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_directory_service.dart';
import '../ui/app_background.dart';

/// Личные сообщения с одним пользователем: `directChats/{chatId}/messages`
class DirectChatScreen extends StatefulWidget {
  final String peerUid;
  final String peerDisplayName;

  const DirectChatScreen({
    super.key,
    required this.peerUid,
    required this.peerDisplayName,
  });

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String get _chatId {
    final me = FirebaseAuth.instance.currentUser?.uid;
    if (me == null) return '';
    return UserDirectoryService.directChatId(me, widget.peerUid);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream() {
    final me = FirebaseAuth.instance.currentUser?.uid;
    if (me == null) return null;
    final id = UserDirectoryService.directChatId(me, widget.peerUid);
    return FirebaseFirestore.instance
        .collection('directChats')
        .doc(id)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(150)
        .snapshots();
  }

  Future<void> _updateChatDocAfterSend(String text) async {
    final me = FirebaseAuth.instance.currentUser?.uid;
    if (me == null) return;
    final ids = [me, widget.peerUid]..sort();
    final preview = text.length > 120 ? '${text.substring(0, 120)}…' : text;
    await FirebaseFirestore.instance.collection('directChats').doc(_chatId).set(
      {
        'participantIds': ids,
        'lastMessageText': preview,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите в аккаунт')),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('directChats')
          .doc(_chatId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _updateChatDocAfterSend(text);
      _textController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось отправить: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final stream = _messagesStream();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.peerDisplayName.isNotEmpty
                              ? widget.peerDisplayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.peerDisplayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Личные сообщения',
                            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: stream == null
                    ? const Center(child: Text('Войдите в аккаунт', style: TextStyle(color: Colors.white70)))
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: stream,
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
                                  child: Text(
                                    'Напишите первое сообщение',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                  ),
                                );
                              }
                              return ListView.builder(
                                reverse: true,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final d = docs[index].data();
                                  final text = d['text'] as String? ?? '';
                                  final senderId = d['senderId'] as String? ?? '';
                                  final isMe = uid != null && senderId == uid;
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
                                      child: Text(
                                        text,
                                        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
