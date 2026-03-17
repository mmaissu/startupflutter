import 'package:flutter/material.dart';

import 'glass_container.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: GlassContainer(
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(12),
            blur: 14,
            fillColor: Colors.white.withValues(alpha: 0.10),
            borderColor: Colors.white.withValues(alpha: 0.14),
            child: Center(
              child: Icon(icon, color: Colors.white.withValues(alpha: 0.95), size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

