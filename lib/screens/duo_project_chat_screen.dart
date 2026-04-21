import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/app_background.dart';

/// Чат внутри дуо-проекта: `duo_projects/{projectId}/messages`
class DuoProjectChatScreen extends StatefulWidget {
  final String projectId;
  final String projectTitle;

  const DuoProjectChatScreen({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  @override
  State<DuoProjectChatScreen> createState() => _DuoProjectChatScreenState();
}

class _DuoProjectChatScreenState extends State<DuoProjectChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _projectStream() {
    return FirebaseFirestore.instance.collection('duo_projects').doc(widget.projectId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _messagesStream() {
    return FirebaseFirestore.instance
        .collection('duo_projects')
        .doc(widget.projectId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(200)
        .snapshots();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите в аккаунт'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('duo_projects')
          .doc(widget.projectId)
          .collection('messages')
          .add({
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
                    Expanded(
                      child: Text(
                        widget.projectTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _projectStream(),
                  builder: (context, projectSnap) {
                    if (projectSnap.hasError) {
                      return Center(
                        child: Text('Ошибка: ${projectSnap.error}', style: const TextStyle(color: Colors.white70)),
                      );
                    }
                    if (projectSnap.connectionState == ConnectionState.waiting && projectSnap.data == null) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white54));
                    }
                    final project = projectSnap.data?.data();
                    final membersRaw = project?['members'];
                    final members = membersRaw is List ? membersRaw.map((e) => e.toString()).toList() : <String>[];
                    final isMember = uid != null && members.contains(uid);

                    if (uid == null) {
                      return const Center(
                        child: Text('Войдите, чтобы видеть чат проекта', style: TextStyle(color: Colors.white70)),
                      );
                    }
                    if (!isMember) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Text(
                            'Чат доступен только участникам проекта.\nНажми «Присоединиться» в деталях проекта.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), height: 1.4),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
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
                                builder: (context, snap) {
                                  if (snap.hasError) {
                                    return Center(
                                      child: Text('Ошибка: ${snap.error}', style: const TextStyle(color: Colors.white70)),
                                    );
                                  }
                                  if (snap.connectionState == ConnectionState.waiting && snap.data == null) {
                                    return const Center(child: CircularProgressIndicator(color: Colors.white54));
                                  }
                                  final docs = snap.data?.docs ?? [];
                                  if (docs.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'Сообщений пока нет',
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    reverse: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    itemCount: docs.length,
                                    itemBuilder: (context, i) {
                                      final d = docs[i].data();
                                      final text = d['text'] as String? ?? '';
                                      final senderId = d['senderId'] as String? ?? '';
                                      final isMe = senderId.isNotEmpty && senderId == uid;
                                      final ts = d['createdAt'];
                                      final time = (ts is Timestamp) ? ts.toDate() : null;

                                      return Align(
                                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
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
                                                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                  stream: FirebaseFirestore.instance.collection('users').doc(senderId).snapshots(),
                                                  builder: (context, uSnap) {
                                                    final name = uSnap.data?.data()?['displayName'] as String? ??
                                                        uSnap.data?.data()?['nickname'] as String? ??
                                                        'Пользователь';
                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 4),
                                                      child: Text(
                                                        name,
                                                        style: TextStyle(
                                                          color: Colors.white.withValues(alpha: 0.45),
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              Text(
                                                text,
                                                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
                                              ),
                                              if (time != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6),
                                                  child: Text(
                                                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 10),
                                                  ),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

