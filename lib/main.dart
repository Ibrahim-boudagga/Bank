import 'package:bank/app/app_widget.dart';
import 'package:bank/app/config/app_config.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig()
    ..setAppName('Bank Wallet')
    ..setDebugShowCheckedModeBanner(false)
    ..setAppTheme(.light)
    ..setShowPerformanceOverlay(false);
  runApp(const AppWidget());
}
