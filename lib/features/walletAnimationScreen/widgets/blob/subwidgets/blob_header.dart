import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Expanded header: "Send" / "Money To" title. Close button is shown separately (sticky in BlobContent).
class BlobHeader extends StatelessWidget {
  const BlobHeader({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final titleFontSize = (screenWidth * 0.05).clamp(18.0, 20.0);
    final largeTitleFontSize = (screenWidth * 0.085).clamp(28.0, 34.0);

    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  'Send',
                  style: AppTextStyles.islandTitle.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: titleFontSize,
                  ),
                  overflow: .ellipsis,
                  maxLines: 1,
                ),
                FittedBox(
                  fit: .scaleDown,
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
          const SizedBox(width: 48, height: 48),
        ],
      ),
    );
  }
}
