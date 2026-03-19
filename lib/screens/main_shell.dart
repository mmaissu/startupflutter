import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Homepage_screen.dart';
import 'account_screen.dart';
import 'projects_screen.dart';
import 'community_screen.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';
import 'Onboarding_screen.dart';

/// Главный экран с нижней навигацией: Главная, Проекты, Чат, Аккаунт
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    HomepageScreen(),
    ProjectsScreen(),
    CommunityScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF1A1D2E),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Text(
                  'Меню',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              _DrawerTile(
                icon: Icons.home_rounded,
                label: 'Главная',
                onTap: () {
                  setState(() => _currentIndex = 0);
                  Navigator.pop(context);
                },
              ),
              _DrawerTile(
                icon: Icons.folder_rounded,
                label: 'Проекты',
                onTap: () {
                  setState(() => _currentIndex = 1);
                  Navigator.pop(context);
                },
              ),
              _DrawerTile(
                icon: Icons.chat_bubble_rounded,
                label: 'Чат',
                onTap: () {
                  setState(() => _currentIndex = 2);
                  Navigator.pop(context);
                },
              ),
              _DrawerTile(
                icon: Icons.person_rounded,
                label: 'Аккаунт',
                onTap: () {
                  setState(() => _currentIndex = 3);
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.white24, height: 24),
              _DrawerTile(
                icon: Icons.settings_rounded,
                label: 'Настройки',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              _DrawerTile(
                icon: Icons.emoji_events_rounded,
                label: 'Мои достижения',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                  );
                },
              ),
              const Divider(color: Colors.white24, height: 24),
              _DrawerTile(
                icon: Icons.logout_rounded,
                label: 'Выйти из аккаунта',
                onTap: () {
                  Navigator.pop(context);
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E2235),
                      title: const Text('Выйти?', style: TextStyle(color: Colors.white)),
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
                          onPressed: () async {
                            Navigator.pop(ctx);
                            await FirebaseAuth.instance.signOut();
                            if (!context.mounted) return;
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
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(0, Icons.home_rounded, 'Главная'),
                _navItem(1, Icons.folder_rounded, 'Проекты'),
                _navItem(2, Icons.chat_bubble_rounded, 'Чат'),
                _navItem(3, Icons.person_rounded, 'Аккаунт'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFF915BFF) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF915BFF) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 24),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
      ),
      onTap: onTap,
    );
  }
}
