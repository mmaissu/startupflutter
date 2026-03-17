import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
                const SizedBox(height: 10),
                Text(
                  'Твой путь к знаниям начинается здесь',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(18),
                    borderRadius: BorderRadius.circular(18),
                    blur: 18,
                    fillColor: Colors.white.withValues(alpha: 0.07),
                    borderColor: Colors.white.withValues(alpha: 0.14),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.palette_rounded, color: Colors.white, size: 44),
                          const SizedBox(height: 12),
                          Text(
                            'ILLUSTRATION 1',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _PagerDots(currentIndex: 0, count: 3),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Продолжить →',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PagerDots extends StatelessWidget {
  final int currentIndex;
  final int count;

  const _PagerDots({required this.currentIndex, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final selected = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: selected ? 28 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: selected ? 0.9 : 0.35),
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }),
    );
  }
}