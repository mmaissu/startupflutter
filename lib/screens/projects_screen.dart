import 'package:flutter/material.dart';
import 'course_detail_screen.dart';

/// Страница "Мои проекты" с карточками курсов и прогрессом
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          _ProjectCard(
            title: 'Основы Python',
            progress: 60,
            lessonText: 'Урок 3 из 5',
            status: ProjectStatus.inProgress,
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
          _ProjectCard(
            title: 'Веб-дизайн в Figma',
            progress: 100,
            lessonText: '6 из 6 уроков',
            status: ProjectStatus.completed,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ProjectCard(
            title: '3D моделирование в Blender',
            progress: 30,
            lessonText: 'Урок 2 из 8',
            status: ProjectStatus.inProgress,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

enum ProjectStatus { inProgress, completed }

class _ProjectCard extends StatelessWidget {
  final String title;
  final int progress;
  final String lessonText;
  final ProjectStatus status;
  final VoidCallback onTap;

  const _ProjectCard({
    required this.title,
    required this.progress,
    required this.lessonText,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                const Color(0xFF915BFF).withOpacity(0.2),
                const Color(0xFFE85D04).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
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
                      value: progress / 100,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF915BFF)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$progress%',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lessonText,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == ProjectStatus.completed
                          ? const Color(0xFF2DD4BF).withOpacity(0.25)
                          : Colors.amber.withOpacity(0.25),
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
