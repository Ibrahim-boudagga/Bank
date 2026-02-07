import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_colors.dart';

part 'border_radius.dart';
part 'shadows.dart';
part 'spacing.dart';
part 'text_styles.dart';

/// Main app theme configuration
class AppTheme {
  AppTheme._();

  //- Light theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: () {
      final base = ColorScheme.fromSeed(seedColor: AppColors.electricAccent, brightness: .light);
      return base.copyWith(
        surface: AppColors.spaceEnd,
        surfaceContainerLowest: AppColors.spaceEnd,
        surfaceContainerLow: AppColors.spaceEnd,
        surfaceContainer: AppColors.spaceEnd,
        surfaceContainerHigh: AppColors.spaceEnd,
        surfaceContainerHighest: AppColors.spaceEnd,
      );
    }(),
    scaffoldBackgroundColor: AppColors.spaceEnd,
  );

  //- Dark theme (main theme for this app)
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: .fromSeed(seedColor: AppColors.electricAccent, brightness: Brightness.dark)
        .copyWith(
          surface: AppColors.spaceEnd,
          surfaceContainerLowest: AppColors.spaceEnd,
          surfaceContainerLow: AppColors.spaceEnd,
          surfaceContainer: AppColors.spaceEnd,
          surfaceContainerHigh: AppColors.spaceEnd,
          surfaceContainerHighest: AppColors.spaceEnd,
        ),
    scaffoldBackgroundColor: AppColors.spaceEnd,
    //@ Customize text theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.balanceAmount,
      displayMedium: AppTextStyles.islandLargeTitle,
      displaySmall: AppTextStyles.cardBrand,
      headlineMedium: AppTextStyles.profileName,
      headlineSmall: AppTextStyles.transactionTitle,
      titleLarge: AppTextStyles.islandSectionTitle,
      titleMedium: AppTextStyles.menuItem,
      titleSmall: AppTextStyles.transactionSubtitle,
      bodyLarge: AppTextStyles.transactionAmount,
      bodyMedium: AppTextStyles.islandContactItem,
      bodySmall: AppTextStyles.transactionLabel,
      labelLarge: AppTextStyles.islandButton,
      labelMedium: AppTextStyles.profileStatValue,
      labelSmall: AppTextStyles.profileStatLabel,
    ),
    //@ Customize input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassSurface,
      border: OutlineInputBorder(borderRadius: AppBorderRadius.badgeRadius, borderSide: .none),
      contentPadding: const .symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    ),
    //@ Customize button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.buttonRadius),
        padding: const .symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
        textStyle: AppTextStyles.islandButton,
      ),
    ),
    //@ Customize card theme
    cardTheme: CardThemeData(
      color: AppColors.glassSurface,
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.contactItemRadius),
      elevation: 0,
    ),
  );

  /// System UI overlay style for status bar
  static SystemUiOverlayStyle get systemUiOverlayStyle => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: .light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: .light,
  );

  /// Get system UI overlay style based on progress (for dynamic status bar)
  static SystemUiOverlayStyle systemUiOverlayStyleForProgress(Brightness brightness) =>
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness,
      );
}
