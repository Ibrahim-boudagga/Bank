import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.text,
    required this.icon,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive ? AppColors.errorRed : Colors.white;
    final iconColor = isDestructive ? AppColors.errorRed : Colors.white;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(icon, color: iconColor, size: 20),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
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
                  color: AppColors.textSecondary.withOpacity(0.5),
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
