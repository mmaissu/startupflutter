import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../ui/app_background.dart';
import '../widgets/glass_container.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const int _pageCount = 3;
  int _page = 0;

  static const List<_OnboardSlide> _slides = [
    _OnboardSlide(
      assetPath: 'assets/onboarding/Снимок экрана 2026-04-21 202645.png',
      caption: 'Курсы по дизайну и творчеству',
    ),
    _OnboardSlide(
      assetPath: 'assets/onboarding/Снимок экрана 2026-04-21 203357.png',
      caption: 'Программирование и практика',
    ),
    _OnboardSlide(
      assetPath: 'assets/onboarding/Снимок экрана 2026-04-21 203653.png',
      caption: 'Прокачивай навыки вместе с сообществом',
    ),
  ];

  void _onContinue() {
    if (_page < _pageCount - 1) {
      setState(() => _page++);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_page];
    final isLast = _page == _pageCount - 1;

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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: Text(
                    slide.caption,
                    key: ValueKey<int>(_page),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: GlassContainer(
                    padding: const EdgeInsets.all(12),
                    borderRadius: BorderRadius.circular(18),
                    blur: 18,
                    fillColor: Colors.white.withValues(alpha: 0.07),
                    borderColor: Colors.white.withValues(alpha: 0.14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.04, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                              child: child,
                            ),
                          );
                        },
                        child: Stack(
                          key: ValueKey<int>(_page),
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              slide.assetPath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_page + 1} / $_pageCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _PagerDots(currentIndex: _page, count: _pageCount),
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
                    onPressed: _onContinue,
                    child: Text(
                      isLast ? 'Перейти к регистрации →' : 'Продолжить →',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

class _OnboardSlide {
  final String assetPath;
  final String caption;

  const _OnboardSlide({
    required this.assetPath,
    required this.caption,
  });
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
