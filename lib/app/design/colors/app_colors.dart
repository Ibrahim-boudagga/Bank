import 'package:flutter/material.dart';

/// Banking-oriented color palette: trust (navy/slate), clarity (neutrals), growth (green).
base class AppColors {
  // ─── Primary (trust, depth) ─────────────────────────────────────────────────
  /// Main navy – headers, cards, primary surfaces.
  static const Color primary = Color(0xFF1E3A5F);

  /// Darker navy – card backs, deep backgrounds.
  static const Color primaryDark = Color(0xFF0F172A);

  // Legacy names (same values for compatibility)
  static const Color spaceStart = primary;
  static const Color spaceEnd = primaryDark;
  static const Color black = Color(0xFF000000);

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color silverText = Color(0xFF94A3B8);

  // ─── Surfaces (light theme) ─────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF8FAFC);

  /// Card/panel background on light (slightly cooler).
  static const Color surfaceCardLight = Color(0xFFF1F5F9);

  // ─── Card (Visa / platinum look) ────────────────────────────────────────────
  static const Color platinumBase = Color(0xFFE2E8F0);
  static const Color platinumDark = Color(0xFFCBD5E1);

  // ─── Accent (CTAs, links – restrained for banking) ──────────────────────────
  static const Color accent = Color(0xFF0D9488);
  static const Color electricAccent = accent;
  static const Color specularWhite = Color(0xFFFFFFFF);

  // ─── Glass / overlay ────────────────────────────────────────────────────────
  static Color get glassSurface => const Color(0xFFFFFFFF).withValues(alpha: 0.06);

  // ─── Status ─────────────────────────────────────────────────────────────────
  static const Color successGreen = Color(0xFF16A34A);
  static const Color successDark = Color(0xFF15803D);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color onlineGreen = Color(0xFF22C55E);

  // ─── Gradients / borders ────────────────────────────────────────────────────
  static List<Color> get iridescentColors => [
    const Color(0xFF0D9488).withValues(alpha: 0.4),
    const Color(0xFF5EEAD4).withValues(alpha: 0.25),
    const Color(0xFFFFFFFF).withValues(alpha: 0.08),
  ];

  // ─── Avatars (muted, professional) ──────────────────────────────────────────
  static List<Color> get avatarColors => const [
    Color(0xFF7DD3FC),
    Color(0xFFA5B4FC),
    Color(0xFF86EFAC),
    Color(0xFFFCD34D),
    Color(0xFFF9A8D4),
    Color(0xFF94A3B8),
  ];
}
