import 'package:flutter/material.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';

/// Экран «Мои достижения»
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const List<Map<String, dynamic>> _achievements = [
    {'title': 'Первый проект', 'subtitle': 'Завершил первый урок', 'done': true},
    {'title': 'Неделя подряд', 'subtitle': 'Занимался 7 дней подряд', 'done': true},
    {'title': '5 проектов', 'subtitle': 'Завершил 5 проектов', 'done': false},
    {'title': '10 уроков', 'subtitle': 'Прослушал 10 уроков', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Мои достижения',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _achievements.length,
                  itemBuilder: (context, index) {
                    final a = _achievements[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlassContainer(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        borderRadius: BorderRadius.circular(14),
                        blur: 16,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        borderColor: Colors.white.withValues(alpha: 0.14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.emoji_events_rounded,
                                color: Colors.white.withValues(alpha: 0.85),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a['title'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    a['subtitle'] as String,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              (a['done'] as bool) ? Icons.check_rounded : Icons.lock_outline_rounded,
                              color: (a['done'] as bool)
                                  ? const Color(0xFF2DD4BF)
                                  : Colors.white.withValues(alpha: 0.35),
                            ),
                          ],
                        ),
                      ),
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
