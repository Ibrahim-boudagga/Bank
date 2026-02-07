import 'package:flutter/material.dart';

base class AppColors {
  // Background colors
  static const Color spaceStart = Color(0xFF1E1B4B);
  static const Color spaceEnd = Color(0xFF020617);

  // Text colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color silverText = Color(0xFF9CA3AF);

  // Card colors
  static const Color platinumBase = Color(0xFFE2E8F0);
  static const Color platinumDark = Color(0xFFCBD5E1);

  // Accent colors
  static const Color electricAccent = Color(0xFF6366F1);
  static const Color specularWhite = Color(0xFFFFFFFF);

  // Glass surface
  static Color glassSurface = const Color(0xFFFFFFFF).withValues(alpha: 0.05);

  // Status colors
  static const Color successGreen = Color(0xFF22C55E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successDark = Color(0xFF166534);
  static const Color onlineGreen = Color(0xFF00E676);

  // Gradient colors for iridescent border
  static List<Color> get iridescentColors => [
    const Color(0xFF818CF8).withValues(alpha: 0.5),
    const Color(0xFFC084FC).withValues(alpha: 0.3),
    const Color(0xFFFFFFFF).withValues(alpha: 0.1),
  ];

  // Avatar colors
  static List<Color> get avatarColors => [
    const Color(0xFFFFCC80),
    const Color(0xFFEF9A9A),
    const Color(0xFF80CBC4),
    const Color(0xFF9FA8DA),
    const Color(0xFFB39DDB),
    const Color(0xFFFFAB91),
  ];
}
