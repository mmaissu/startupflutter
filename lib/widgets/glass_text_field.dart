import 'package:flutter/material.dart';

import 'glass_container.dart';

class GlassTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final bool obscureText;

  const GlassTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(14),
      blur: 16,
      fillColor: Colors.white.withValues(alpha: 0.10),
      borderColor: Colors.white.withValues(alpha: 0.14),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

