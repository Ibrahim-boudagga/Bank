part of 'app_theme.dart';

/// Shared gradients using [AppColors]. Change here to update card UI everywhere.
class AppGradients {
  AppGradients._();

  /// Main card face (front and back).
  static const LinearGradient cardBackground = LinearGradient(
    colors: [AppColors.platinumBase, AppColors.platinumDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Card back variant (slightly diagonal).
  static const LinearGradient cardBackBackground = LinearGradient(
    colors: [AppColors.platinumBase, AppColors.platinumDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Overlay on card back (subtle highlight).
  static LinearGradient get cardBackOverlay => LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Magnetic stripe on card back.
  static const LinearGradient cardMagStripe = LinearGradient(
    colors: [
      Color(0xFF303030),
      Colors.black,
      Colors.black,
      Color(0xFF303030),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
