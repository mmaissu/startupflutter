import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _GradientLayer(),
        const _DecorCircles(),
        child,
      ],
    );
  }
}

class _GradientLayer extends StatelessWidget {
  const _GradientLayer();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF102A3A),
              Color(0xFF6A63FF),
              Color(0xFFFF5AA5),
            ],
            stops: [0.0, 0.65, 1.0],
          ),
        ),
      ),
    );
  }
}

class _DecorCircles extends StatelessWidget {
  const _DecorCircles();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              left: -80,
              top: 220,
              child: _Circle(color: const Color(0xFF2E4CFF).withValues(alpha: 0.20), size: 220),
            ),
            Positioned(
              right: -70,
              top: 120,
              child: _Circle(color: const Color(0xFFFF5AA5).withValues(alpha: 0.25), size: 260),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final Color color;
  final double size;

  const _Circle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

