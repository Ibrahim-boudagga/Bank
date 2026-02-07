import 'package:bank/app/app_widget.dart';
import 'package:bank/app/config/app_config.dart';
import 'package:flutter/material.dart';

void main() {
  AppConfig()..setAppName('Bank Wallet')..setDebugShowCheckedModeBanner(false);
  runApp(const AppWidget());
}
