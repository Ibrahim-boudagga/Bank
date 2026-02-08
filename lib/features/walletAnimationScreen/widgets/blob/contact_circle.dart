import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Circle avatar with optional online indicator and name label for blob suggested contacts.
class ContactCircle extends StatelessWidget {
  const ContactCircle({super.key, required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?',
                  style: AppTextStyles.islandContactName.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onlineGreen,
                border: Border.all(color: AppColors.spaceEnd, width: 2),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(name, style: AppTextStyles.islandContactName.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
