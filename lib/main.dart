import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/Onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Показывать ошибки вместо белого экрана
  ErrorWidget.builder = (details) => Material(
        child: Container(
          color: Colors.red.shade900,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                details.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      );

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    debugPrint('Firebase init error: $e\n$stack');
  }
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1D2E),
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingScreen(),
    );
  }
}