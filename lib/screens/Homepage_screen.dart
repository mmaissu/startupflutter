import 'package:flutter/material.dart';
import 'course_detail_screen.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E),
      appBar: AppBar(
        title: const Text(
          "Популярные проекты",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          _buildProjectCard(
            context,
            "3D моделирование",
            "Создай свой первый 3D объект",
            const Color(0xFF915BFF),
            "blender_3d",
          ),
          const SizedBox(height: 16),
          _buildProjectCard(
            context,
            "Python основы",
            "Изучи базу программирования",
            const Color(0xFF5B8CFF),
            "python_basics",
          ),
          const SizedBox(height: 16),
          _buildProjectCard(
            context,
            "Веб-дизайн в Figma",
            "Создавай интерфейсы и прототипы",
            const Color(0xFFE85D04),
            "figma_design",
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    String courseId,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                courseTitle: title,
                courseId: courseId,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}