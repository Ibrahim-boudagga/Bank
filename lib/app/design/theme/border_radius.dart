part of 'app_theme.dart';

/// Border radius constants used throughout the app
class AppBorderRadius {
  AppBorderRadius._();

  // Base radius
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 22.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Specific radius from design
  static const double card = 24.0;
  static const double contactItem = 22.0;
  static const double badge = 6.0;
  static const double button = 32.0;
  static const double islandStart = 28.0;
  static const double islandEnd = 32.0;
  static const double menuItem = 16.0;

  // BorderRadius objects
  static const BorderRadius cardRadius = .all(.circular(card));
  static const BorderRadius contactItemRadius = .all(.circular(contactItem));
  static const BorderRadius badgeRadius = .all(.circular(badge));
  static const BorderRadius buttonRadius = .all(.circular(button));
  static const BorderRadius islandStartRadius = .all(.circular(islandStart));
  static const BorderRadius islandEndRadius = .all(.circular(islandEnd));
}
