import 'package:flutter/material.dart';
import 'main_shell.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: GlassContainer(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                  borderRadius: BorderRadius.circular(18),
                  blur: 18,
                  fillColor: Colors.white.withValues(alpha: 0.10),
                  borderColor: Colors.white.withValues(alpha: 0.16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Регистрация',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Создайте свой аккаунт',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                      ),
                      const SizedBox(height: 18),
                      const GlassTextField(
                        hintText: 'Введите email или телефон',
                      ),
                      const SizedBox(height: 12),
                      const GlassTextField(
                        hintText: 'Создайте пароль',
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      const GlassTextField(
                        hintText: 'Повторите пароль',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Забыли пароль?',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MainShell()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Зарегистрироваться',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text.rich(
                        TextSpan(
                          text: 'Уже есть аккаунт? ',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12),
                          children: const [
                            TextSpan(
                              text: 'Войти',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}