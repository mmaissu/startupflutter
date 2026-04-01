import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_directory_service.dart';
import 'main_shell.dart';
import 'register_screen.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Введите email');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Введите пароль');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        await UserDirectoryService.instance.ensurePublicProfile(cred.user!);
      }
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = switch (e.code) {
          'user-not-found' => 'Пользователь не найден',
          'wrong-password' => 'Неверный пароль',
          'invalid-email' => 'Некорректный email',
          'invalid-credential' => 'Неверный email или пароль',
          'user-disabled' => 'Аккаунт отключён',
          _ => e.message ?? 'Ошибка входа',
        };
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка входа';
      });
    }
  }

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
                        'Вход',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Войдите в свой аккаунт',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                      ),
                      const SizedBox(height: 18),
                      if (_errorMessage != null) ...[
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                      ],
                      GlassTextField(
                        controller: _emailController,
                        hintText: 'Введите email',
                      ),
                      const SizedBox(height: 12),
                      GlassTextField(
                        controller: _passwordController,
                        hintText: 'Пароль',
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
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : const Text(
                                  'Войти',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'Нет аккаунта? ',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12),
                            children: const [
                              TextSpan(
                                text: 'Зарегистрироваться',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
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
