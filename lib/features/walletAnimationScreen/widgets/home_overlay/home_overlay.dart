import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../blob/blob_content.dart';

/// Overlay for wallet home: profile button, add-money button, and draggable Dynamic Island.
/// Stack this on top of the main scroll content. Same design as example [HomeContent] overlay.
class HomeOverlay extends StatefulWidget {
  const HomeOverlay({
    super.key,
    required this.topPadding,
    required this.onProfileClick,
    this.showProfileButton = true,
    this.isLoading = false,
  });

  final double topPadding;
  final VoidCallback onProfileClick;
  final bool showProfileButton;
  final bool isLoading;

  @override
  State<HomeOverlay> createState() => _HomeOverlayState();
}

class _HomeOverlayState extends State<HomeOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _islandController;
  double _islandHeight = AppSpacing.islandStartHeight;
  double _islandProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _islandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _islandController.dispose();
    super.dispose();
  }

  void _updateIslandProgress(double height) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final startHeight = AppSpacing.islandStartHeight;
    final progress = ((height - startHeight) / (endHeight - startHeight)).clamp(0.0, 1.0);
    setState(() => _islandProgress = progress);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final newHeight = (_islandHeight + details.delta.dy).clamp(
      AppSpacing.islandStartHeight,
      endHeight,
    );
    setState(() => _islandHeight = newHeight);
    _updateIslandProgress(newHeight);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final threshold = (AppSpacing.islandStartHeight + endHeight) / 2;
    final velocity = details.velocity.pixelsPerSecond.dy;

    final shouldExpand = velocity > 500 || _islandHeight > threshold;
    final targetHeight = shouldExpand ? endHeight : AppSpacing.islandStartHeight;

    _islandController.reset();
    _islandController.forward().then((_) {
      setState(() => _islandHeight = targetHeight);
      _updateIslandProgress(targetHeight);
    });
  }

  void _closeIsland() {
    _islandController.reset();
    _islandController.forward().then((_) {
      setState(() => _islandHeight = AppSpacing.islandStartHeight);
      _updateIslandProgress(AppSpacing.islandStartHeight);
    });
  }

  static const double _profileButtonSize = 52.0;
  static const double _gapBetweenButtonAndIsland = 16.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final leftZoneEnd =
        AppSpacing.screenHorizontal + _profileButtonSize + _gapBetweenButtonAndIsland;
    final rightZoneStart =
        screenWidth - AppSpacing.screenHorizontal - _profileButtonSize - _gapBetweenButtonAndIsland;
    final middleZoneWidth = (rightZoneStart - leftZoneEnd).clamp(0.0, double.infinity);
    final endWidth = middleZoneWidth;

    final widthProgress = _cubicBezierEasing(_islandProgress);
    final currentWidth = _lerp(AppSpacing.islandStartWidth, endWidth, widthProgress);
    final islandWidth = currentWidth.clamp(0.0, middleZoneWidth);
    final islandLeft = leftZoneEnd + (middleZoneWidth - islandWidth) / 2;
    final currentRadius = _lerp(
      AppSpacing.islandStartRadius,
      AppSpacing.islandEndRadius,
      widthProgress,
    );

    final smoothProgress = _islandProgress;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (widget.showProfileButton)
          Positioned(
            top: widget.topPadding + 2,
            left: AppSpacing.screenHorizontal,
            child: IgnorePointer(
              ignoring: smoothProgress > 0.1,
              child: Opacity(
                opacity: 1 - smoothProgress,
                child: GestureDetector(
                  onTap: widget.onProfileClick,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricAccent.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: widget.topPadding + 2,
          right: AppSpacing.screenHorizontal,
          child: Opacity(
            opacity: 1 - smoothProgress,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.spaceStart, AppColors.spaceEnd],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                  color: AppColors.electricAccent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
        Positioned(
          top: widget.topPadding,
          left: islandLeft,
          child: Skeletonizer(
            enabled: widget.isLoading,
            enableSwitchAnimation: true,
            child: IgnorePointer(
              ignoring: widget.isLoading,
              child: GestureDetector(
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: Container(
                  width: islandWidth,
                  height: _islandHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(currentRadius),
                    gradient: const LinearGradient(
                      colors: [AppColors.spaceStart, AppColors.spaceEnd],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      width: 1,
                      color: AppColors.electricAccent.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.8 * smoothProgress),
                        blurRadius: smoothProgress * 40,
                        spreadRadius: smoothProgress * 5,
                      ),
                      BoxShadow(
                        color: const Color(0xFFC084FC).withValues(alpha: 0.8 * smoothProgress),
                        blurRadius: smoothProgress * 40,
                        spreadRadius: smoothProgress * 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(currentRadius),
                    child: BlobContent(progress: smoothProgress, onClose: _closeIsland),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _lerp(double start, double end, double t) => start + (end - start) * t;

  double _cubicBezierEasing(double t) => t * t * (3.0 - 2.0 * t);
}
