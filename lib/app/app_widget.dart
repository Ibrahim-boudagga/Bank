import 'package:bank/app/config/app_config.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:bank/features/profile/profile_screen.dart';
import 'package:bank/features/walletAnimationScreen/wallet_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

    return MaterialApp(
      title: appConfig.appName ?? 'Bank Wallet',
      debugShowCheckedModeBanner: appConfig.debugShowCheckedModeBanner,
      theme: appConfig.appTheme ?? AppTheme.darkTheme,
      showPerformanceOverlay: appConfig.showPerformanceOverlay,
      home: WalletAnimationScreen(),
      routes: {'/profile': (context) => ProfileScreen()},
    );
  }
}
