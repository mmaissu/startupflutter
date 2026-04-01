import 'package:flutter/material.dart';

import '../course_lessons_catalog.dart';
import '../models/lesson_models.dart';
import '../services/course_progress_service.dart';
import 'course_detail_screen.dart';

/// Страница «Мои проекты»: прогресс синхронизирован с курсами и Firestore.
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ProjectsScreenState createState() => ProjectsScreenState();
}

class ProjectsScreenState extends State<ProjectsScreen> {
  bool _loading = true;
  final Map<String, Map<String, bool>> _completedByCourse = {};

  static const List<_ProjectEntry> _entries = [
    _ProjectEntry(
      title: 'Основы Python',
      courseId: 'python_basics',
    ),
    _ProjectEntry(
      title: 'UI/UX дизайн',
      courseId: 'ui_ux',
    ),
    _ProjectEntry(
      title: '3D моделирование',
      courseId: 'blender_3d',
    ),
  ];

  @override
  void initState() {
    super.initState();
    refreshProgress();
  }

  /// Вызывается при переключении на вкладку «Проекты» и после возврата с экрана курса.
  Future<void> refreshProgress() async {
    setState(() => _loading = true);
    final maps = await Future.wait(
      _entries.map((e) => CourseProgressService.instance.loadCompletedLessons(e.courseId)),
    );
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < _entries.length; i++) {
        _completedByCourse[_entries[i].courseId] = maps[i];
      }
      _loading = false;
    });
  }

  void _openCourse(_ProjectEntry entry) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CourseDetailScreen(
          courseTitle: entry.title,
          courseId: entry.courseId,
        ),
      ),
    ).then((_) => refreshProgress());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Мои проекты',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white54))
          : RefreshIndicator(
              color: const Color(0xFF915BFF),
              onRefresh: refreshProgress,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < _entries.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    _ProjectCard(
                      entry: _entries[i],
                      completedMap: _completedByCourse[_entries[i].courseId] ?? {},
                      onTap: () => _openCourse(_entries[i]),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _ProjectEntry {
  final String title;
  final String courseId;

  const _ProjectEntry({
    required this.title,
    required this.courseId,
  });
}

class _ProjectCard extends StatelessWidget {
  final _ProjectEntry entry;
  final Map<String, bool> completedMap;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.entry,
    required this.completedMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lessons = CourseLessonsCatalog.lessonsFor(entry.courseId);
    final total = lessons.length;
    final completed = lessons.where((LessonDefinition l) => completedMap[l.id] == true).length;
    final pct = total == 0 ? 0 : ((completed / total) * 100).round();
    final status = total > 0 && completed >= total ? ProjectStatus.completed : ProjectStatus.inProgress;
    final lessonText = total == 0 ? 'Нет уроков' : '$completed из $total уроков';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF915BFF).withValues(alpha: 0.2),
                const Color(0xFFE85D04).withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    status == ProjectStatus.completed ? Icons.check_circle_rounded : Icons.schedule_rounded,
                    color: status == ProjectStatus.completed ? const Color(0xFF2DD4BF) : Colors.amber,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : (completed / total).clamp(0.0, 1.0),
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF915BFF)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$pct%',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lessonText,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == ProjectStatus.completed
                          ? const Color(0xFF2DD4BF).withValues(alpha: 0.25)
                          : Colors.amber.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status == ProjectStatus.completed ? 'ЗАВЕРШЁН' : 'В ПРОЦЕССЕ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: status == ProjectStatus.completed ? const Color(0xFF2DD4BF) : Colors.amber,
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

enum ProjectStatus { inProgress, completed }
