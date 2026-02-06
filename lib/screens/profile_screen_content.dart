import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_stat_box.dart';

class ProfileScreenContent extends StatelessWidget {
  final bool isOpen;
  final double progress;
  final double topPadding;
  final VoidCallback? onBack;

  const ProfileScreenContent({
    super.key,
    required this.isOpen,
    required this.progress,
    required this.topPadding,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    final nameFontSize = (screenWidth * 0.05).clamp(18.0, 20.0) * textScale;
    final verifiedFontSize = (screenWidth * 0.035).clamp(12.0, 14.0) * textScale;

    final alpha = progress;
    final scale = _lerp(0.92, 1.0, progress);
    final slideY = _lerp(50.0, 0.0, progress);

    return Opacity(
      opacity: alpha,
      child: Transform.scale(
        scale: scale,
        child: Transform.translate(
          offset: Offset(0, slideY),
          child: Container(
            color: AppColors.spaceEnd,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: topPadding + 60, left: 24, right: 24, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80 + 100),
                      const SizedBox(height: 24),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppConstants.profileName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Verified Account",
                        style: TextStyle(
                          color: AppColors.electricAccent,
                          fontSize: verifiedFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileStatBox(
                            label: "Income",
                            value: "\$8.2k",
                            icon: Icons.arrow_upward,
                            color: AppColors.successGreen,
                          ),
                          ProfileStatBox(
                            label: "Spent",
                            value: "\$3.4k",
                            icon: Icons.arrow_downward,
                            color: AppColors.errorRed,
                          ),
                          ProfileStatBox(
                            label: "Saved",
                            value: "\$12k",
                            icon: Icons.savings,
                            color: AppColors.electricAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          ProfileMenuItem(text: "Account Settings", icon: Icons.settings),
                          const SizedBox(height: 12),
                          ProfileMenuItem(text: "Notifications", icon: Icons.notifications),
                          const SizedBox(height: 12),
                          ProfileMenuItem(text: "Privacy & Security", icon: Icons.security),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                // Back button
                if (onBack != null)
                  Positioned(
                    top: topPadding + 8,
                    left: 24,
                    child: GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glassSurface,
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }
}
