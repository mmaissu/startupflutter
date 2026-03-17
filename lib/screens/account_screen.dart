import 'package:flutter/material.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_icon_button.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';
import 'Onboarding_screen.dart';

/// Страница аккаунта: аватар, имя, интересы, завершённые проекты, достижения
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
                        'Аккаунт',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  GlassIconButton(
                    icon: Icons.settings_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GlassContainer(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                borderRadius: BorderRadius.circular(16),
                blur: 16,
                fillColor: Colors.white.withValues(alpha: 0.08),
                borderColor: Colors.white.withValues(alpha: 0.14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A63FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Алексей',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'alex@example.com',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(height: 1, color: Colors.white.withValues(alpha: 0.14)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _StatTile(icon: Icons.track_changes_rounded, value: '12', label: 'Проектов'),
                        _StatTile(icon: Icons.menu_book_rounded, value: '48', label: 'Уроков'),
                        _StatTile(icon: Icons.local_fire_department_rounded, value: '7', label: 'Дней подряд'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Достижения',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 18),
              const Text(
                'Настройки и выход',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              GlassContainer(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(16),
                blur: 16,
                fillColor: Colors.white.withValues(alpha: 0.08),
                borderColor: Colors.white.withValues(alpha: 0.14),
                child: Column(
                  children: [
                    _AccountPanelTile(
                      icon: Icons.settings_rounded,
                      label: 'Настройки',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      ),
                    ),
                    Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
                    _AccountPanelTile(
                      icon: Icons.emoji_events_rounded,
                      label: 'Мои достижения',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF1E2235),
                        title: const Text('Выйти из аккаунта?', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'Вы уверены, что хотите выйти?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Выйти', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Достижения',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const _AchievementRow(
                title: 'Первый проект',
                subtitle: 'Завершил первый урок',
                done: true,
              ),
              const SizedBox(height: 10),
              const _AchievementRow(
                title: 'Неделя подряд',
                subtitle: 'Занимался 7 дней подряд',
                done: true,
              ),
              const SizedBox(height: 10),
              const _AchievementRow(
                title: '5 проектов',
                subtitle: 'Завершил 5 проектов',
                done: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatTile({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.85)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10)),
      ],
    );
  }
}

class _AccountPanelTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AccountPanelTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;

  const _AchievementRow({required this.title, required this.subtitle, required this.done});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
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
            child: Icon(Icons.military_tech_rounded, color: Colors.white.withValues(alpha: 0.85), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
              ],
            ),
          ),
          Icon(
            done ? Icons.check_rounded : Icons.lock_outline_rounded,
            color: done ? const Color(0xFF2DD4BF) : Colors.white.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
