import 'package:flutter/material.dart';

import '../course_lessons_catalog.dart';
import '../models/lesson_models.dart';
import '../services/course_progress_service.dart';
import 'lesson_theory_screen.dart';

/// Страница курса с уроками и статусами: заблокирован / начать / в процессе / завершён
class CourseDetailScreen extends StatefulWidget {
  final String courseTitle;
  final String courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseTitle,
    required this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Map<String, bool> _completed = {};
  String? _inProgressLessonId;
  bool _loading = true;

  List<LessonDefinition> get _lessons => CourseLessonsCatalog.lessonsFor(widget.courseId);

  @override
  void initState() {
    super.initState();
    _reloadProgress();
  }

  Future<void> _reloadProgress({bool forceServer = false}) async {
    setState(() => _loading = true);
    final map = await CourseProgressService.instance.loadCompletedLessons(
      widget.courseId,
      forceServer: forceServer,
    );
    if (mounted) {
      setState(() {
        _completed = map;
        _loading = false;
      });
    }
  }

  LessonStatus _statusFor(int index, LessonDefinition lesson) {
    if (_completed[lesson.id] == true) return LessonStatus.completed;
    if (_inProgressLessonId == lesson.id) return LessonStatus.inProgress;
    if (index == 0) return LessonStatus.available;
    final prev = _lessons[index - 1];
    if (_completed[prev.id] == true) return LessonStatus.available;
    return LessonStatus.locked;
  }

  int get _completedCount => _lessons.where((l) => _completed[l.id] == true).length;

  double get _progressValue {
    if (_lessons.isEmpty) return 0;
    return _completedCount / _lessons.length;
  }

  Future<void> _onLessonAction(LessonDefinition lesson, LessonStatus status) async {
    if (status == LessonStatus.locked) return;
    if (status == LessonStatus.completed) return;

    setState(() => _inProgressLessonId = lesson.id);

    final passed = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        builder: (context) => LessonTheoryScreen(
          courseTitle: widget.courseTitle,
          lesson: lesson,
        ),
      ),
    );

    if (!mounted) return;
    setState(() => _inProgressLessonId = null);

    if (passed == null) return;

    if (passed == true) {
      setState(() {
        _completed[lesson.id] = true;
      });
      final synced = await CourseProgressService.instance.markLessonCompleted(
        widget.courseId,
        lesson.id,
      );
      await _reloadProgress(forceServer: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            synced
                ? 'Урок завершён, прогресс сохранён'
                : 'Урок засчитан в приложении. Не удалось синхронизировать с облаком — проверьте интернет и правила Firestore для users/{uid}.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (passed == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Тест не пройден (нужно не менее 70% верных). Прогресс курса не изменён.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.courseTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white54))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainCourseCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Уроки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < _lessons.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _LessonCard(
                        lesson: _lessons[i],
                        status: _statusFor(i, _lessons[i]),
                        onTap: () => _onLessonAction(_lessons[i], _statusFor(i, _lessons[i])),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildMainCourseCard() {
    final pct = (_progressValue * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF915BFF),
            Color(0xFFE85D04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF915BFF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.courseTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Изучи материал по шагам: теория, блоки про программы и установку, затем тест из 10 вопросов.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.95),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.menu_book_rounded, size: 18, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 6),
              Text(
                '${_lessons.length} уроков',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _progressValue.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Прогресс: $pct%',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonDefinition lesson;
  final LessonStatus status;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locked = status == LessonStatus.locked;
    final completed = status == LessonStatus.completed;
    final inProgress = status == LessonStatus.inProgress;
    final available = status == LessonStatus.available;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: completed
                      ? const Color(0xFF2DD4BF).withOpacity(0.25)
                      : locked
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : locked
                          ? Icons.lock_outline_rounded
                          : inProgress
                              ? Icons.menu_book_rounded
                              : Icons.play_arrow_rounded,
                  color: completed
                      ? const Color(0xFF2DD4BF)
                      : locked
                          ? Colors.white38
                          : Colors.white70,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 15,
                    color: locked ? Colors.white54 : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (available)
                const Text(
                  'Начать',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                )
              else if (inProgress)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    'В процессе',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade200,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else if (completed)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF2DD4BF), size: 22)
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
