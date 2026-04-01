import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/direct_chat_screen.dart';
import '../services/user_directory_service.dart';
import 'community_messages_panel.dart';
import 'direct_conversations_list.dart';

/// Вкладка «Чаты»: поиск пользователя по имени/email и общий чат.
class ChatTabWithSearch extends StatefulWidget {
  const ChatTabWithSearch({super.key});

  @override
  State<ChatTabWithSearch> createState() => _ChatTabWithSearchState();
}

class _ChatTabWithSearchState extends State<ChatTabWithSearch> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<UserSearchHit> _results = [];
  bool _searching = false;
  String? _lastQuery;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final q = value.trim();
      if (q.length < 2) {
        if (mounted) setState(() {
          _results = [];
          _lastQuery = null;
        });
        return;
      }
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) setState(() => _results = []);
        return;
      }
      if (mounted) setState(() => _searching = true);
      final hits = await UserDirectoryService.instance.searchUsers(q, excludeUid: user.uid);
      if (!mounted) return;
      setState(() {
        _searching = false;
        _results = hits;
        _lastQuery = q;
      });
    });
  }

  void _openDirectChat(UserSearchHit hit) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Войдите в аккаунт')),
      );
      return;
    }
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => DirectChatScreen(
          peerUid: hit.uid,
          peerDisplayName: hit.displayName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (loggedIn) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Личные сообщения',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const DirectConversationsList(),
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.5)),
            hintText: loggedIn ? 'Поиск по имени или email…' : 'Войдите, чтобы искать людей',
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
          enabled: loggedIn,
        ),
        if (loggedIn)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Минимум 2 символа. Выбери человека — откроется личный чат.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11),
            ),
          ),
        if (_searching)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54))),
          )
        else if (loggedIn &&
            !_searching &&
            _searchController.text.trim().length >= 2 &&
            _results.isEmpty &&
            _lastQuery == _searchController.text.trim().toLowerCase())
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  'Никого не найдено',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  'Должен существовать другой пользователь приложения. В правилах Firestore для users нужно: allow read: if request.auth != null. Свой профиль обновляется при каждом входе.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.38), fontSize: 11, height: 1.35),
                ),
              ],
            ),
          )
        else if (_results.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Material(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: _results.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                itemBuilder: (context, i) {
                  final h = _results[i];
                  return ListTile(
                    dense: true,
                    title: Text(
                      h.displayName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: h.email != null
                        ? Text(
                            h.email!,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: TextButton(
                      onPressed: () => _openDirectChat(h),
                      child: const Text('Написать'),
                    ),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Общий чат сообщества',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Expanded(child: CommunityMessagesPanel(skipOuterTitle: true)),
      ],
    );
  }
}
