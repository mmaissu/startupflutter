import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../course_lessons_catalog.dart';
import '../models/lesson_models.dart';
import '../services/course_progress_service.dart';
import 'course_detail_screen.dart';
import 'duo_project_detail_screen.dart';
import '../models/duo_project.dart';

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
                  const SizedBox(height: 4),
                  Text(
                    'Курсы',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < _entries.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    _ProjectCard(
                      entry: _entries[i],
                      completedMap: _completedByCourse[_entries[i].courseId] ?? {},
                      onTap: () => _openCourse(_entries[i]),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Text(
                    'Дуо проекты (где вы участник)',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _MyDuoProjectsSection(),
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

class _MyDuoProjectsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Text(
        'Войдите в аккаунт, чтобы видеть дуо‑проекты, где вы участник.',
        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), height: 1.35),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('duo_projects')
          .where('members', arrayContains: uid)
          .snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Text(
            'Ошибка загрузки дуо‑проектов: ${snap.error}',
            style: const TextStyle(color: Colors.white70),
          );
        }
        if (snap.connectionState == ConnectionState.waiting && snap.data == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator(color: Colors.white54)),
          );
        }
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return Text(
            'Пока вы не участник ни одного дуо‑проекта. Откройте проект в «Чате → Дуо проекты» и нажмите «Присоединиться».',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), height: 1.35),
          );
        }

        final list = docs
            .map((d) => DuoProject.fromFirestoreDocument(d.id, d.data()))
            .toList()
          ..sort((a, b) => b.deadline.compareTo(a.deadline));

        return Column(
          children: [
            for (var i = 0; i < list.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _DuoMiniCard(
                project: list[i],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DuoProjectDetailScreen(projectId: list[i].id),
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DuoMiniCard extends StatelessWidget {
  final DuoProject project;
  final VoidCallback onTap;

  const _DuoMiniCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A63FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.groups_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      project.type,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${project.currentMemberCount}/${project.teamSizeTarget} · ${project.deadlineLabel}',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
