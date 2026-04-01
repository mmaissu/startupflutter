import 'package:flutter/material.dart';

import '../models/lesson_models.dart';
import 'lesson_quiz_screen.dart';

/// Теория урока (теория → ПО → установка) и переход к тесту
class LessonTheoryScreen extends StatelessWidget {
  final String courseTitle;
  final LessonDefinition lesson;

  const LessonTheoryScreen({
    super.key,
    required this.courseTitle,
    required this.lesson,
  });

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
          lesson.title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              courseTitle,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Теория'),
                  const SizedBox(height: 8),
                  Text(
                    lesson.theory,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Какие программы использовать'),
                  const SizedBox(height: 8),
                  Text(
                    lesson.softwareSection,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Как скачать и установить'),
                  const SizedBox(height: 8),
                  Text(
                    lesson.installationGuide,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  final passed = await Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonQuizScreen(lesson: lesson),
                    ),
                  );
                  if (context.mounted) {
                    if (passed == null) return;
                    Navigator.pop(context, passed);
                  }
                },
                child: const Text('Перейти к тесту', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }
}
