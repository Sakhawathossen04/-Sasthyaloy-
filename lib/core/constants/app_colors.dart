import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (Matching reference screenshots)
  static const Color primaryNavy = Color(0xFF0B3C68);
  static const Color primaryDark = Color(0xFF002D62);
  static const Color brandCyan = Color(0xFF0084FF);
  static const Color emeraldGreen = Color(0xFF00C48C);
  static const Color accentGreen = Color(0xFF10B981);
  
  // Emergency & Alerts
  static const Color sosRed = Color(0xFFE63946);
  static const Color warningOrange = Color(0xFFF59E0B);
  
  // Neutrals & Surfaces
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFEDF2F7);

  // Typography Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Chips & Tags
  static const Color chipBackground = Color(0xFFEBF4FF);
  static const Color chipText = Color(0xFF0B3C68);

  // Gradient definitions
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryNavy, brandCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF07213A), Color(0xFF0B3C68), Color(0xFF0D47A1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0B3C68), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
