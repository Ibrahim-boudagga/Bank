part of 'app_theme.dart';

/// Text styles used throughout the app, extracted from the Kotlin design
class AppTextStyles {
  AppTextStyles._();

  // Card Text Styles
  static const TextStyle cardBrand = TextStyle(
    fontSize: 22,
    fontWeight: .w800,
    letterSpacing: 1.0,
    color: Colors.white,
  );

  static const TextStyle cardVirtual = TextStyle(fontSize: 10, fontWeight: .bold);

  static const TextStyle cardNumber = TextStyle(
    fontSize: 20,
    fontWeight: .bold,
    fontFamily: 'monospace',
  );

  static const TextStyle cardVisa = TextStyle(
    fontSize: 28,
    fontWeight: .w900,
    fontStyle: .italic,
    letterSpacing: -1.0,
  );

  // Balance Text Styles
  static const TextStyle balanceAmount = TextStyle(
    fontSize: 34,
    fontWeight: .w800,
    letterSpacing: -1.0,
    fontFamily: 'monospace',
  );

  static const TextStyle balanceBadge = TextStyle(fontSize: 13, fontWeight: .bold);

  // Profile Text Styles
  static const TextStyle profileName = TextStyle(
    fontSize: 20,
    fontWeight: .bold,
    color: Colors.white,
  );

  static const TextStyle profileVerified = TextStyle(fontSize: 14, fontWeight: .w500);

  static const TextStyle profileStatValue = TextStyle(
    fontSize: 16,
    fontWeight: .bold,
    color: Colors.white,
  );

  static const TextStyle profileStatLabel = TextStyle(fontSize: 12, color: Colors.white70);

  // Menu Item Text Styles
  static const TextStyle menuItem = TextStyle(fontSize: 16, fontWeight: .w500, color: Colors.white);

  // Dynamic Island Text Styles
  static const TextStyle islandTitle = TextStyle(fontSize: 20, color: Colors.white70);

  static const TextStyle islandLargeTitle = TextStyle(
    fontSize: 34,
    fontWeight: .w800,
    letterSpacing: -1.0,
    color: Colors.white,
  );

  static const TextStyle islandSectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: .bold,
    color: Colors.white,
  );

  static const TextStyle islandContactName = TextStyle(fontSize: 12, color: Colors.white70);

  static const TextStyle islandContactItem = TextStyle(
    fontSize: 16,
    fontWeight: .w600,
    color: Colors.white,
  );

  static const TextStyle islandContactSubtitle = TextStyle(fontSize: 12, color: Colors.white70);

  static const TextStyle islandButton = TextStyle(
    fontSize: 17,
    fontWeight: .bold,
    color: Colors.black,
  );

  static const TextStyle islandPill = TextStyle(fontSize: 16, fontWeight: .w500);

  // Transaction Text Styles
  static const TextStyle transactionTitle = TextStyle(
    fontSize: 18,
    fontWeight: .bold,
    color: Colors.black87,
  );

  static const TextStyle transactionSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: .w600,
    color: Colors.black54,
  );

  static const TextStyle transactionAmount = TextStyle(
    fontSize: 16,
    fontWeight: .bold,
    color: Colors.black87,
  );

  static const TextStyle transactionLabel = TextStyle(
    fontSize: 12,
    fontWeight: .w500,
    color: Colors.black54,
  );

  // Card Back Text Styles
  static const TextStyle cardBackLabel = TextStyle(
    fontSize: 10,
    fontWeight: .bold,
    letterSpacing: 1.0,
    color: Colors.black54,
  );

  static const TextStyle cardBackValue = TextStyle(
    fontSize: 17,
    fontWeight: .bold,
    letterSpacing: 0.5,
    color: Colors.black87,
  );

  static const TextStyle cardBackCvv = TextStyle(
    fontSize: 11,
    fontWeight: .bold,
    color: Colors.black87,
  );

  static const TextStyle cardBackCvvLabel = TextStyle(fontSize: 10, color: Colors.black54);
}
