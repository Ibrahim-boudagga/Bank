import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:bank/core/base/view/sub_view.dart';
import 'package:bank/features/common/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cubit/wallet_animation_cubit.dart';
import '../../cubit/wallet_animation_state.dart';
import '../blob/blob_content.dart';

/// Overlay for wallet home: profile button, add-money button, and draggable Dynamic Island.
/// Logic lives in [HomeOverlayCubitMixin]; this widget is UI only.
class HomeOverlay extends SubView<WalletAnimationCubit> {
  const HomeOverlay({
    super.key,
    required this.topPadding,
    required this.profileImageUrl,
    this.profileName,
    this.profileColor,
    this.showProfileButton = true,
    this.isLoading = false,
  });

  final double topPadding;
  final String profileImageUrl;

  /// Used for contact-style fallback (first letter + color) when image fails or is empty.
  final String? profileName;

  /// Used for contact-style fallback. Defaults to [AppColors.spaceStart] if null.
  final Color? profileColor;
  final bool showProfileButton;
  final bool isLoading;

  static const double _profileButtonSize = 52.0;
  static const double _gapBetweenButtonAndIsland = 16.0;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WalletAnimationCubit, WalletAnimationState, IslandState>(
      selector: (state) => state.islandState,
      builder: (context, state) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final screenHeight = MediaQuery.sizeOf(context).height;
        final smoothProgress = state.progress;

        final leftZoneEnd =
            AppSpacing.screenHorizontal + _profileButtonSize + _gapBetweenButtonAndIsland;
        final rightZoneStart =
            screenWidth -
            AppSpacing.screenHorizontal -
            _profileButtonSize -
            _gapBetweenButtonAndIsland;
        final middleZoneWidth = (rightZoneStart - leftZoneEnd).clamp(0.0, double.infinity);
        // Collapsed: same pill width. Expanded: much wider (nearly full screen).
        const expandedHorizontalPadding = 16.0;
        final expandedMaxWidth = screenWidth - expandedHorizontalPadding * 2;
        final widthProgress = _cubicBezierEasing(smoothProgress);
        final currentWidth = _lerp(AppSpacing.islandStartWidth, expandedMaxWidth, widthProgress);
        final islandWidth = currentWidth;
        // When collapsed: center in middle zone. When expanded: center on screen.
        final collapsedLeft = leftZoneEnd + (middleZoneWidth - islandWidth) / 2;
        final expandedLeft = (screenWidth - islandWidth) / 2;
        final islandLeft = _lerp(collapsedLeft, expandedLeft, widthProgress);
        final currentRadius = _lerp(
          AppSpacing.islandStartRadius,
          AppSpacing.islandEndRadius,
          widthProgress,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (showProfileButton)
              Positioned(
                top: topPadding + 2,
                left: AppSpacing.md,
                child: IgnorePointer(
                  ignoring: smoothProgress > 0.1,
                  child: Opacity(
                    opacity: 1 - smoothProgress,
                    child: GestureDetector(
                      onTap: () => cubit.openProfile(),
                      behavior: .opaque,
                      child: AvatarImage(
                        url: profileImageUrl,
                        size: .new(_profileButtonSize, _profileButtonSize),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: topPadding + 2,
              right: AppSpacing.md,
              child: Opacity(
                opacity: 1 - smoothProgress,
                child: Container(
                  width: _profileButtonSize,
                  height: _profileButtonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.spaceStart, AppColors.spaceEnd],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: .all(color: AppColors.electricAccent.withValues(alpha: 0.5), width: 1),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            ),
            Positioned(
              top: topPadding,
              left: islandLeft,
              child: Skeletonizer(
                enabled: isLoading,
                enableSwitchAnimation: true,
                child: IgnorePointer(
                  ignoring: isLoading,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) =>
                        cubit.onIslandDragUpdate(details.delta.dy, screenHeight),
                    onVerticalDragEnd: (details) =>
                        cubit.onIslandDragEnd(details.velocity.pixelsPerSecond.dy, screenHeight),
                    child: Container(
                      width: islandWidth,
                      height: state.height,
                      decoration: BoxDecoration(
                        borderRadius: .circular(currentRadius),
                        gradient: const LinearGradient(
                          colors: [AppColors.spaceStart, AppColors.spaceEnd],
                          begin: .topCenter,
                          end: .bottomCenter,
                        ),
                        border: .all(
                          width: 1,
                          color: AppColors.electricAccent.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.8 * smoothProgress),
                            blurRadius: smoothProgress,
                            spreadRadius: smoothProgress,
                          ),
                          BoxShadow(
                            color: AppColors.spaceStart.withValues(alpha: 0.8 * smoothProgress),

                            blurRadius: smoothProgress,
                            spreadRadius: smoothProgress,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(currentRadius),
                        child: BlobContent(
                          progress: smoothProgress,
                          onClose: cubit.closeIsland,
                          suggestedContactNames: cubit.suggestedContactNames,
                          suggestedContactColors: cubit.suggestedContactColors,
                          contactListNames: cubit.contactListNames,
                          contactListInitials: cubit.contactListInitials,
                          avatarColorForIndex: cubit.avatarColorForIndex,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static double _lerp(double start, double end, double t) => start + (end - start) * t;

  static double _cubicBezierEasing(double t) => t * t * (3.0 - 2.0 * t);
}
