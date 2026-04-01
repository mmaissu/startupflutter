import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_directory_service.dart';
import 'main_shell.dart';
import 'login_screen.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Введите email');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Введите пароль');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Пароль должен быть не менее 6 символов');
      return;
    }
    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Пароли не совпадают');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
          'email-already-in-use' => 'Этот email уже занят',
          'invalid-email' => 'Некорректный email',
          'weak-password' => 'Пароль слишком простой',
          _ => e.message ?? 'Ошибка регистрации',
        };
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка регистрации';
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
                        hintText: 'Создайте пароль',
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      GlassTextField(
                        controller: _confirmPasswordController,
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
                          onPressed: _isLoading ? null : _register,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : const Text(
                                  'Зарегистрироваться',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text.rich(
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