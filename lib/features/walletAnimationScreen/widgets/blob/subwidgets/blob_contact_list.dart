import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Sliver list of contact rows with progress-based stagger animation.
class BlobContactList extends StatelessWidget {
  const BlobContactList({
    super.key,
    required this.progress,
    required this.contactListNames,
    required this.contactListInitials,
    required this.avatarColorForIndex,
  });

  final double progress;
  final List<String> contactListNames;
  final List<String> contactListInitials;
  final Color Function(int index) avatarColorForIndex;

  static double _lerp(double start, double end, double t) =>
      start + (end - start) * t;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contactItemFontSize = (screenWidth * 0.04).clamp(14.0, 16.0);
    final contactSubtitleFontSize = (screenWidth * 0.03).clamp(10.0, 12.0);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final start = 0.4 + (index * 0.05);
          const end = 1.0;
          final itemProgress = ((progress - start) / (end - start)).clamp(0.0, 1.0);
          final itemScale = _lerp(0.8, 1.0, itemProgress);
          final itemAlpha = itemProgress;
          final itemTranslationY = (1.0 - itemProgress) * 100.0;

          return Transform.translate(
            offset: Offset(0, itemTranslationY),
            child: Transform.scale(
              scale: itemScale,
              child: Opacity(
                opacity: itemAlpha,
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.glassSurface,
                    borderRadius:
                        BorderRadius.circular(AppBorderRadius.contactItem),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: avatarColorForIndex(index),
                        ),
                        child: Center(
                          child: Text(
                            index < contactListInitials.length
                                ? contactListInitials[index]
                                : '',
                            style: AppTextStyles.islandContactItem.copyWith(
                              color: AppColors.black.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index < contactListNames.length
                                  ? contactListNames[index]
                                  : '',
                              style: AppTextStyles.islandContactItem.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: contactItemFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'Recent transfer',
                              style: AppTextStyles.islandContactSubtitle
                                  .copyWith(
                                color: AppColors.textSecondary,
                                fontSize: contactSubtitleFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: contactListNames.length,
      ),
    );
  }
}
