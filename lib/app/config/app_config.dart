import 'package:flutter/material.dart';

import '../design/theme/app_theme.dart';

final appConfig = AppConfig.instance;

class AppConfig {
  AppConfig._();

  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._();

  String? appName;
  bool debugShowCheckedModeBanner = false;
  bool showPerformanceOverlay = false;
  ThemeData? appTheme;

  AppConfig setAppName(String name) {
    appName = name;
    return this;
  }

  AppConfig setDebugShowCheckedModeBanner(bool show) {
    debugShowCheckedModeBanner = show;
    return this;
  }

  AppConfig setAppTheme(Brightness brightness) {
    appTheme = brightness == .light ? AppTheme.lightTheme : AppTheme.darkTheme;
    return this;
  }

  AppConfig setShowPerformanceOverlay(bool show) {
    showPerformanceOverlay = show;
    return this;
  }
}
