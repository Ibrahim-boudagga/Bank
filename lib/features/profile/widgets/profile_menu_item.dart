import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Menu row: icon, label, chevron. Uses design tokens.
class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.text,
    required this.icon,
    this.isDestructive = false,
    this.onTap,
  });

  final String text;
  final IconData icon;
  final bool isDestructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? AppColors.errorRed : Colors.white;
    final iconColor = isDestructive ? AppColors.errorRed : Colors.white;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(icon, color: iconColor, size: 20),
                      const SizedBox(width: AppSpacing.lg),
                      Flexible(
                        child: Text(
                          text,
                          style: AppTextStyles.menuItem.copyWith(
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
