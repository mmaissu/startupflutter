import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edu App Design',
      theme: ThemeData(
        // Твои макеты темные, поэтому устанавливаем темную тему по умолчанию
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1D2E), // Основной темный фон
        primarySwatch: Colors.blue,
        // Можно сразу задать шрифт, если он отличается от стандартного
        fontFamily: 'Inter', 
      ),
      home: const OnboardingScreen(),
    );
  }
}