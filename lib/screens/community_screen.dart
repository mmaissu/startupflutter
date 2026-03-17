import 'package:flutter/material.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_icon_button.dart';
import '../widgets/glass_text_field.dart';
import 'chat_conversation_screen.dart';

/// Страница "Сообщество" (Чат) — поиск и список пользователей
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _segmentChats = true; // true = Чаты, false = Дуо проекты
  String _selectedInterest = 'Все';
  static const List<String> _interests = ['Все', '3D', 'Blender', 'Python', 'UI/UX', 'Веб', 'Дизайн', 'Боты'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            children: [
              Row(
                children: [
                  GlassIconButton(
                    icon: Icons.menu_rounded,
                    onTap: () => Scaffold.of(context).openDrawer(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Чат',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 12),
              _SegmentedTabs(
                isChats: _segmentChats,
                onChatsTap: () => setState(() => _segmentChats = true),
                onDuoTap: () => setState(() => _segmentChats = false),
              ),
              const SizedBox(height: 10),
              const GlassTextField(hintText: 'Поиск по имени, интересам или чатам...'),
              const SizedBox(height: 14),
              const Text(
                'Найти по интересам',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final label in _interests)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedInterest = label),
                          child: _PillChip(label: label, selected: _selectedInterest == label),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Собеседники',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 94,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _PeerAvatar(letter: 'М', name: 'Мария', tag: '3D - Blender', onTap: () => _openChat(context, 'Мария', 'М')),
                    const SizedBox(width: 12),
                    _PeerAvatar(letter: 'Д', name: 'Дмитрий', tag: 'Python - Боты', onTap: () => _openChat(context, 'Дмитрий', 'Д')),
                    const SizedBox(width: 12),
                    _PeerAvatar(letter: 'А', name: 'Анна', tag: 'UI/UX дизайн', onTap: () => _openChat(context, 'Анна', 'А')),
                    const SizedBox(width: 12),
                    _PeerAvatar(letter: 'И', name: 'Илья', tag: 'Веб-разработ', onTap: () => _openChat(context, 'Илья', 'И')),
                    const SizedBox(width: 12),
                    _PeerAvatar(letter: 'С', name: 'София', tag: 'Мобильные пр...', onTap: () => _openChat(context, 'София', 'С')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Чаты',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              _ChatRow(
                letter: 'М',
                name: 'Мария',
                message: 'Привет! Готова скинуть референсы по моделированию',
                time: '14:32',
                unreadCount: 2,
                onTap: () => _openChat(context, 'Мария', 'М'),
              ),
              const SizedBox(height: 10),
              _ChatRow(
                letter: 'Д',
                name: 'Дмитрий',
                message: 'Могу помочь с ботом, напиши что нужно',
                time: 'Вчера',
                unreadCount: 0,
                onTap: () => _openChat(context, 'Дмитрий', 'Д'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context, String name, String letter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConversationScreen(name: name, letter: letter),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final bool isChats;
  final VoidCallback onChatsTap;
  final VoidCallback onDuoTap;

  const _SegmentedTabs({
    required this.isChats,
    required this.onChatsTap,
    required this.onDuoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onChatsTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                  color: isChats ? Colors.white : Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Center(
                  child: Text(
                    'Чаты',
                    style: TextStyle(
                      color: isChats ? Colors.black : Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDuoTap,
              borderRadius: BorderRadius.circular(10),
              child: GlassContainer(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(10),
                blur: 14,
                fillColor: isChats ? Colors.white.withValues(alpha: 0.10) : Colors.white.withValues(alpha: 0.25),
                borderColor: Colors.white.withValues(alpha: 0.14),
                child: Center(
                  child: Text(
                    'Дуо проекты',
                    style: TextStyle(
                      color: isChats ? Colors.white.withValues(alpha: 0.7) : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _PillChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.white.withValues(alpha: 0.12);
    final fg = selected ? Colors.black : Colors.white.withValues(alpha: 0.85);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _PeerAvatar extends StatelessWidget {
  final String letter;
  final String name;
  final String tag;
  final VoidCallback onTap;

  const _PeerAvatar({
    required this.letter,
    required this.name,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          GlassContainer(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(24),
            blur: 14,
            fillColor: Colors.white.withValues(alpha: 0.10),
            borderColor: Colors.white.withValues(alpha: 0.14),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
          Text(tag, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.65))),
        ],
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  final String letter;
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const _ChatRow({
    required this.letter,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      borderRadius: BorderRadius.circular(16),
      blur: 16,
      fillColor: Colors.white.withValues(alpha: 0.08),
      borderColor: Colors.white.withValues(alpha: 0.14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Center(
              child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 10)),
              const SizedBox(height: 6),
              if (unreadCount > 0)
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF915BFF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }
}
