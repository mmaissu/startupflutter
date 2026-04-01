import 'package:flutter/material.dart';
import 'course_detail_screen.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_icon_button.dart';
import '../widgets/glass_text_field.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String _selectedFilter = 'Все';
  static const List<String> _filters = ['Все', 'Blender', 'Python', 'Design'];

  void _onFilterTap(String label) {
    setState(() => _selectedFilter = label);
    if (label == 'Все') return;

    final CourseDetailScreen? screen = switch (label) {
      'Blender' => const CourseDetailScreen(
          courseTitle: '3D моделирование',
          courseId: 'blender_3d',
        ),
      'Python' => const CourseDetailScreen(
          courseTitle: 'Основы Python',
          courseId: 'python_basics',
        ),
      'Design' => const CourseDetailScreen(
          courseTitle: 'UI/UX дизайн',
          courseId: 'ui_ux',
        ),
      _ => null,
    };
    if (screen == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

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
                  const Spacer(),
                  GlassIconButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Уведомления'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const GlassTextField(hintText: 'Поиск проектов...'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final label in _filters)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _onFilterTap(label),
                          child: _PillChip(label: label, selected: _selectedFilter == label),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Популярные проекты',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 12),
              _ProjectRowCard(
                title: '3D моделирование',
                subtitle: 'Создай свой первый 3D объект',
                icon: Icons.layers_rounded,
                iconBg: const Color(0xFF915BFF),
                peopleText: '1.2k',
                lessonsText: '5 уроков',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CourseDetailScreen(
                      courseTitle: '3D моделирование',
                      courseId: 'blender_3d',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ProjectRowCard(
                title: 'Python основы',
                subtitle: 'Изучи язык программирования',
                icon: Icons.code_rounded,
                iconBg: const Color(0xFF5B8CFF),
                peopleText: '2.5k',
                lessonsText: '8 уроков',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CourseDetailScreen(
                      courseTitle: 'Основы Python',
                      courseId: 'python_basics',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ProjectRowCard(
                title: 'UI/UX дизайн',
                subtitle: 'Научись создавать интерфейсы',
                icon: Icons.palette_rounded,
                iconBg: const Color(0xFFFF8A3D),
                peopleText: '1.1k',
                lessonsText: '7 уроков',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CourseDetailScreen(
                      courseTitle: 'UI/UX дизайн',
                      courseId: 'ui_ux',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _ProjectRowCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final String peopleText;
  final String lessonsText;
  final VoidCallback onTap;

  const _ProjectRowCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.peopleText,
    required this.lessonsText,
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
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          borderRadius: BorderRadius.circular(16),
          blur: 16,
          fillColor: Colors.white.withValues(alpha: 0.08),
          borderColor: Colors.white.withValues(alpha: 0.14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people_outline_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(peopleText, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
                        const SizedBox(width: 10),
                        Icon(Icons.schedule_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          lessonsText,
                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.6), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}