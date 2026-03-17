import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final Color fillColor;
  final Color borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blur = 18,
    this.fillColor = const Color(0x1FFFFFFF),
    this.borderColor = const Color(0x22FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

