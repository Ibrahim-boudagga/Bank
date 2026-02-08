import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'subwidgets/subwidgets.dart';

/// Content shown inside the Dynamic Island when expanded: "Send Money To", contacts, list, continue.
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
    final buttonScale = (progress * 1.5 - 0.5).clamp(0.0, 1.0);

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
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: CustomScrollView(
                slivers: [
                  BlobHeader(screenWidth: screenWidth, onClose: onClose),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                  BlobSuggestedContacts(
                    bubbleScale: bubbleScale,
                    suggestedContactNames: suggestedContactNames,
                    suggestedContactColors: suggestedContactColors,
                    avatarColorForIndex: avatarColorForIndex,
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                  const SliverToBoxAdapter(child: BlobSectionTitle()),
                  const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                  BlobContactList(
                    progress: progress,
                    contactListNames: contactListNames,
                    contactListInitials: contactListInitials,
                    avatarColorForIndex: avatarColorForIndex,
                  ),
                  SliverToBoxAdapter(
                    child: BlobContinueButton(
                      screenWidth: screenWidth,
                      buttonScale: buttonScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
