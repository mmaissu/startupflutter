import 'package:flutter/material.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Светлый фон как в Figma
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            children: [
              const Spacer(),
              // Текст приветствия
              const Text("Welcome", style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold)),
              const Text("Твой путь к знаниям начинается здесь", style: TextStyle(color: Colors.grey, fontSize: 16)),
              const Spacer(),
              // Прямоугольник для иллюстрации
              Container(
                height: 300,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                child: const Center(child: Text("ILLUSTRATION", style: TextStyle(color: Colors.black54))),
              ),
              const Spacer(flex: 2),
              // Кнопка продолжить внизу
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 5, // Небольшая тень
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: const Text("Продолжить →", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}