import 'package:flutter/material.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2E), // Твой темный фон из Figma
      appBar: AppBar(
        title: const Text("Популярные проекты"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Карточка 1: 3D моделирование
            _buildProjectCard(
              "3D моделирование", 
              "Создай свой первый 3D объект", 
              const Color(0xFF915BFF)
            ),
            const SizedBox(height: 16),
            // Карточка 2: Python
            _buildProjectCard(
              "Python основы", 
              "Изучи базу программирования", 
              const Color(0xFF5B8CFF)
            ),
          ],
        ),
      ),
      // Нижнее меню как на твоем скриншоте
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1D2E),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Проекты"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Чат"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Аккаунт"),
        ],
      ),
    );
  }

  // Вспомогательный виджет для создания карточек
  Widget _buildProjectCard(String title, String subtitle, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}