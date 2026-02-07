part of 'app_theme.dart';

/// Shadow and elevation constants used throughout the app
class AppShadows {
  AppShadows._();

  // Card shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  // Avatar shadow
  static List<BoxShadow> get avatarShadow => [
    BoxShadow(
      color: const Color(0xFF6366F1).withValues(alpha: 0.8),
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    ),
  ];

  // Island shadow (dynamic based on progress)
  static List<BoxShadow> islandShadow(double progress) => [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.8 * progress),
      blurRadius: 40 * progress,
      spreadRadius: 5 * progress,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFFC084FC).withValues(alpha: 0.8 * progress),
      blurRadius: 40 * progress,
      spreadRadius: 2 * progress,
      offset: const Offset(0, 2),
    ),
  ];

  // Glass surface shadow
  static List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  // Button shadow
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
}
