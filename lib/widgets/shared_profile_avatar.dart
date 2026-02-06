import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/constants.dart';

class SharedProfileAvatar extends StatelessWidget {
  final double progress;
  final double screenWidth;
  final double topPadding;
  final double alpha;
  final VoidCallback onClick;

  const SharedProfileAvatar({
    super.key,
    required this.progress,
    required this.screenWidth,
    required this.topPadding,
    required this.alpha,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final startSize = AppConstants.startAvatarSize;
    final endSize = AppConstants.endAvatarSize;
    final startX = 24.0;
    final startY = topPadding + 2.0;
    final endX = (screenWidth - endSize) / 2;
    final endY = topPadding + 80.0;

    final currentSize = _lerp(startSize, endSize, progress);
    final currentX = _lerp(startX, endX, progress);
    final currentY = _lerp(startY, endY, progress);
    final currentBorderWidth = _lerp(1.0, 2.0, progress);
    final currentShadow = _lerp(0.0, 20.0, progress);
    final currentIconSize = _lerp(24.0, 48.0, progress);

    final borderColor = progress < 0.5
        ? AppColors.electricAccent.withOpacity(0.5)
        : Colors.white.withOpacity(0.5);

    return Positioned(
      left: currentX,
      top: currentY,
      child: IgnorePointer(
        ignoring: alpha <= 0.01,
        child: Hero(
          tag: 'profile_avatar',
          flightShuttleBuilder:
              (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(
                            begin: 0.8,
                            end: 1.0,
                          ).chain(CurveTween(curve: Curves.easeOutCubic)),
                        ),
                        child: child!,
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: currentSize,
                      height: currentSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.spaceStart, AppColors.spaceEnd],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border.all(color: borderColor, width: currentBorderWidth),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricAccent.withOpacity(0.8),
                            blurRadius: currentShadow,
                            spreadRadius: currentShadow * 0.1,
                          ),
                        ],
                      ),
                      child: Icon(Icons.person, color: Colors.white, size: currentIconSize),
                    ),
                  ),
                );
              },
          child: Opacity(
            opacity: alpha,
            child: GestureDetector(
              onTap: onClick,
              behavior: HitTestBehavior.opaque,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: currentSize,
                  height: currentSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.spaceStart, AppColors.spaceEnd],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(color: borderColor, width: currentBorderWidth),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricAccent.withOpacity(0.8),
                        blurRadius: currentShadow,
                        spreadRadius: currentShadow * 0.1,
                      ),
                    ],
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: currentIconSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }
}
