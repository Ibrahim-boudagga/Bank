import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/spacing.dart';

/// Collapsed pill row: "Send to" + overlapping contact avatars.
class BlobPillContent extends StatelessWidget {
  const BlobPillContent({
    super.key,
    required this.pillAlpha,
    required this.suggestedContactNames,
    required this.suggestedContactColors,
    required this.avatarColorForIndex,
  });

  final double pillAlpha;
  final List<String> suggestedContactNames;
  final List<Color> suggestedContactColors;
  final Color Function(int index) avatarColorForIndex;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Opacity(
      opacity: pillAlpha,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding / 1.5),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Send',
                    style: AppTextStyles.islandPill.copyWith(color: AppColors.silverText),
                  ),
                  HorizontalSpacing(spacing: screenWidth * 0.01),
                  Text(
                    'to',
                    style: AppTextStyles.islandPill.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
              Row(
                children: [
                  for (int i = 0; i < suggestedContactNames.length; i++)
                    Transform.translate(
                      offset: Offset(i > 0 ? -8.0 * i : 0, 0),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < suggestedContactColors.length
                              ? suggestedContactColors[i]
                              : avatarColorForIndex(i),
                          border: Border.all(color: AppColors.spaceStart, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            suggestedContactNames[i].substring(0, 1),
                            style: AppTextStyles.islandContactName.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
