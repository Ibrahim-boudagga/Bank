import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Stat card: icon, value, label. Uses design tokens.
class ProfileStatBox extends StatelessWidget {
  const ProfileStatBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.2);
    final valueFontSize = (screenWidth * 0.04).clamp(14.0, 16.0) * textScale;
    final labelFontSize = (screenWidth * 0.03).clamp(10.0, 12.0) * textScale;
    final iconSize = (screenWidth * 0.05).clamp(18.0, 20.0);
    final boxWidth = (screenWidth * 0.25).clamp(80.0, 100.0);

    return Container(
      width: boxWidth,
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(height: screenWidth * 0.02),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.profileStatValue.copyWith(
                fontSize: valueFontSize,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.profileStatLabel.copyWith(
                color: AppColors.textSecondary,
                fontSize: labelFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
