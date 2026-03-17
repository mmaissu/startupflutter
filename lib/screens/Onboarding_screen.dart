import 'package:flutter/material.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Чистый белый фон
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            children: [
              const Spacer(),
              // Текст приветствия
              const Text(
                "Welcome", 
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 42, // Чуть крупнее
                  fontWeight: FontWeight.w900, // Жирный шрифт
                  letterSpacing: -1, // Плотное написание как в Figma
                )
              ),
              const SizedBox(height: 10),
              const Text(
                "Твой путь к знаниям начинается здесь", 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const Spacer(),
              
              // Область для иллюстрации (островок)
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7), // Светло-серый "островок"
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, size: 80, color: Colors.grey), // Временная иконка
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Кнопка продолжить
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0, // Убираем стандартную тень
                    side: const BorderSide(color: Color(0xFFEEEEEE)), // Тонкая рамка
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // Переход на регистрацию
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterScreen())
                    );
                  },
                  child: const Text(
                    "Продолжить →", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
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