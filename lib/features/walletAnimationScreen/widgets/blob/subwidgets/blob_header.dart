import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Expanded header: "Send" / "Money To" title and close button.
class BlobHeader extends StatelessWidget {
  const BlobHeader({
    super.key,
    required this.screenWidth,
    required this.onClose,
  });

  final double screenWidth;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final titleFontSize = (screenWidth * 0.05).clamp(18.0, 20.0);
    final largeTitleFontSize = (screenWidth * 0.085).clamp(28.0, 34.0);

    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send',
                  style: AppTextStyles.islandTitle.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: titleFontSize,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: AppSpacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Money To',
                    style: AppTextStyles.islandLargeTitle.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: largeTitleFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.glassSurface,
              shape: const CircleBorder(),
              side: BorderSide(
                color: AppColors.specularWhite.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
