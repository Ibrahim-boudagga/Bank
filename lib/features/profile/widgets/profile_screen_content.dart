import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'profile_menu_item.dart';
import 'profile_stat_box.dart';

/// Profile screen body: avatar area, name, stats, menu items. Uses design tokens.
class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({
    super.key,
    this.profileName = 'Kyriakos Georgiopoulos',
    this.topPadding = 0,
    this.onBack,
  });

  final String profileName;
  final double topPadding;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.2);
    final nameFontSize = (screenWidth * 0.05).clamp(18.0, 20.0) * textScale;
    final verifiedFontSize = (screenWidth * 0.035).clamp(12.0, 14.0) * textScale;

    return Container(
      color: AppColors.spaceEnd,
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: topPadding + 60,
                  left: AppSpacing.screenHorizontal,
                  right: AppSpacing.screenHorizontal,
                  bottom: AppSpacing.xxxl,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 80 + AppSpacing.profileAvatarSpacing),
                    const SizedBox(height: AppSpacing.screenVertical),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        profileName,
                        style: AppTextStyles.profileName.copyWith(
                          fontSize: nameFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppBorderRadius.xs),
                    Text(
                      'Verified Account',
                      style: AppTextStyles.profileVerified.copyWith(
                        color: AppColors.electricAccent,
                        fontSize: verifiedFontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfileStatBox(
                          label: 'Income',
                          value: '\$8.2k',
                          icon: Icons.arrow_upward,
                          color: AppColors.successGreen,
                        ),
                        ProfileStatBox(
                          label: 'Spent',
                          value: '\$3.4k',
                          icon: Icons.arrow_downward,
                          color: AppColors.errorRed,
                        ),
                        ProfileStatBox(
                          label: 'Saved',
                          value: '\$12k',
                          icon: Icons.savings,
                          color: AppColors.electricAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    const ProfileMenuItem(
                      text: 'Account Settings',
                      icon: Icons.settings,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const ProfileMenuItem(
                      text: 'Notifications',
                      icon: Icons.notifications,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const ProfileMenuItem(
                      text: 'Privacy & Security',
                      icon: Icons.security,
                    ),
                    const SizedBox(height: AppSpacing.screenVertical),
                  ]),
                ),
              ),
            ],
          ),
          if (onBack != null)
            Positioned(
              top: topPadding + AppSpacing.sm,
              left: AppSpacing.screenHorizontal,
              child: GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.glassSurface,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
