import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'subwidgets/subwidgets.dart';

/// Content shown inside the Dynamic Island when expanded: "Send Money To", contacts, list.
/// Data (names, colors) is provided by the parent from [BlobContentCubitMixin].
class BlobContent extends StatelessWidget {
  const BlobContent({
    super.key,
    required this.progress,
    required this.onClose,
    required this.suggestedContactNames,
    required this.suggestedContactColors,
    required this.contactListNames,
    required this.contactListInitials,
    required this.avatarColorForIndex,
  });

  final double progress;
  final VoidCallback onClose;
  final List<String> suggestedContactNames;
  final List<Color> suggestedContactColors;
  final List<String> contactListNames;
  final List<String> contactListInitials;
  final Color Function(int index) avatarColorForIndex;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final pillAlpha = progress < 0.5 ? (1.0 - (progress * 5.0)).clamp(0.0, 1.0) : 0.0;
    final contentAlpha = ((progress - 0.2) / 0.4).clamp(0.0, 1.0);
    final contentParallax = (1.0 - progress) * 100.0;
    final bubbleScale = (progress * 1.2).clamp(0.0, 1.0);

    return Stack(
      children: [
        if (pillAlpha > 0)
          BlobPillContent(
            pillAlpha: pillAlpha,
            suggestedContactNames: suggestedContactNames,
            suggestedContactColors: suggestedContactColors,
            avatarColorForIndex: avatarColorForIndex,
          ),
        Transform.translate(
          offset: Offset(0, contentParallax),
          child: Opacity(
            opacity: contentAlpha,
            child: Stack(
              children: [
                Padding(
                  padding: const .only(
                    left: AppSpacing.xl,
                    right: AppSpacing.xl,
                    top: AppSpacing.xxxl,
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) => true,
                    child: CustomScrollView(
                      slivers: [
                        BlobHeader(screenWidth: screenWidth),
                        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                        BlobSuggestedContacts(
                          bubbleScale: bubbleScale,
                          suggestedContactNames: suggestedContactNames,
                          suggestedContactColors: suggestedContactColors,
                          avatarColorForIndex: avatarColorForIndex,
                        ),
                        const BlobPinnedSectionTitle(),
                        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                        BlobContactList(
                          progress: progress,
                          contactListNames: contactListNames,
                          contactListInitials: contactListInitials,
                          avatarColorForIndex: avatarColorForIndex,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.xl,
                  child: IconButton(
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
