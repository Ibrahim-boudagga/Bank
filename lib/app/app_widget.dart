import 'package:bank/app/config/app_config.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:bank/screens/walletAnimationScreen/walet_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appConfig = AppConfig();

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

    return MaterialApp(
      title: appConfig.appName ?? 'Bank Wallet',
      debugShowCheckedModeBanner: appConfig.debugShowCheckedModeBanner,
      theme: AppTheme.lightTheme,
      home: const WalletAnimationScreen(),
    );
  }
}
