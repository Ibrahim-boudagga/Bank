import 'package:bank/app/design/theme/app_theme.dart';
import 'package:bank/core/base/cubit/base_cubit.dart';
import 'package:flutter/scheduler.dart';

import '../../../cubit/wallet_animation_state.dart';

/// Mixin that provides Dynamic Island drag and expand/collapse logic for [WalletAnimationState].
/// Use from a [SubView] that displays the overlay; call [onIslandDragUpdate], [onIslandDragEnd], [closeIsland].
/// Animations run over [_snapDuration] with smooth easing, driven by frame callbacks.
mixin HomeOverlayCubitMixin on BaseCubit<WalletAnimationState> {
  static const Duration _snapDuration = Duration(milliseconds: 400);
  bool _islandAnimationActive = false;

  void _cancelIslandAnimation() {
    _islandAnimationActive = false;
  }

  /// Smooth ease-in-out cubic for snap animations.
  static double _easeInOutCubic(double t) {
    if (t < 0.5) return 4 * t * t * t;
    final u = -2 * t + 2;
    return 1 - (u * u * u) / 2;
  }

  void _animateIslandTo(double targetHeight, double targetProgress) {
    _cancelIslandAnimation();
    final startHeight = state.islandState.height;
    final startProgress = state.islandState.progress;
    final startTime = DateTime.now().millisecondsSinceEpoch;
    _islandAnimationActive = true;

    void onFrame() {
      if (!_islandAnimationActive || isClosed) return;

      final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
      final t = (elapsed / _snapDuration.inMilliseconds).clamp(0.0, 1.0);
      final easedT = _easeInOutCubic(t);
      final height = startHeight + (targetHeight - startHeight) * easedT;
      final progress = startProgress + (targetProgress - startProgress) * easedT;

      emit(
        state.copyWith(
          islandState: state.islandState.copyWith(height: height, progress: progress),
        ),
      );

      if (t >= 1.0) {
        _islandAnimationActive = false;
        if (!isClosed) {
          emit(
            state.copyWith(
              islandState: state.islandState.copyWith(
                height: targetHeight,
                progress: targetProgress,
              ),
            ),
          );
        }
        return;
      }

      SchedulerBinding.instance.scheduleFrameCallback((_) => onFrame());
    }

    SchedulerBinding.instance.scheduleFrameCallback((_) => onFrame());
  }

  /// Call from GestureDetector.onVerticalDragUpdate. [screenHeight] from MediaQuery.sizeOf(context).height.
  void onIslandDragUpdate(double deltaDy, double screenHeight) {
    _cancelIslandAnimation();
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final current = state.islandState;
    final newHeight = (current.height + deltaDy).clamp(AppSpacing.islandStartHeight, endHeight);
    final progress = _islandProgressFromHeight(newHeight, screenHeight);
    emit(
      state.copyWith(
        islandState: current.copyWith(height: newHeight, progress: progress),
      ),
    );
  }

  /// Call from GestureDetector.onVerticalDragEnd. [velocityDy] from details.velocity.pixelsPerSecond.dy.
  /// Smoothly animates to expanded or collapsed over [_snapDuration].
  void onIslandDragEnd(double velocityDy, double screenHeight) {
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final threshold = (AppSpacing.islandStartHeight + endHeight) / 2;
    final currentHeight = state.islandState.height;
    final shouldExpand = velocityDy > 500 || currentHeight > threshold;
    final targetHeight = shouldExpand ? endHeight : AppSpacing.islandStartHeight;
    final targetProgress = _islandProgressFromHeight(targetHeight, screenHeight);
    _animateIslandTo(targetHeight, targetProgress);
  }

  /// Collapse the island by reversing the expand animation (e.g. from BlobContent onClose).
  void closeIsland() {
    _animateIslandTo(AppSpacing.islandStartHeight, 0.0);
  }

  double _islandProgressFromHeight(double height, double screenHeight) {
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final startHeight = AppSpacing.islandStartHeight;
    final range = (endHeight - startHeight).clamp(1.0, double.infinity);
    return ((height - startHeight) / range).clamp(0.0, 1.0);
  }
}
