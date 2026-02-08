import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../contact_circle.dart';

/// Horizontal list of suggested contact circles + "Add" tile.
class BlobSuggestedContacts extends StatelessWidget {
  const BlobSuggestedContacts({
    super.key,
    required this.bubbleScale,
    required this.suggestedContactNames,
    required this.suggestedContactColors,
    required this.avatarColorForIndex,
  });

  final double bubbleScale;
  final List<String> suggestedContactNames;
  final List<Color> suggestedContactColors;
  final Color Function(int index) avatarColorForIndex;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            Expanded(
              child: Transform.scale(
                scale: bubbleScale,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestedContactNames.length + 1,
                  itemBuilder: (context, index) {
                    if (index < suggestedContactNames.length) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < suggestedContactNames.length - 1
                              ? AppSpacing.lg
                              : 0,
                        ),
                        child: ContactCircle(
                          name: suggestedContactNames[index],
                          color: index < suggestedContactColors.length
                              ? suggestedContactColors[index]
                              : avatarColorForIndex(index),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.specularWhite.withValues(alpha: 0.05),
                              border: Border.all(
                                color: AppColors.specularWhite.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Add',
                            style: AppTextStyles.islandContactName.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
