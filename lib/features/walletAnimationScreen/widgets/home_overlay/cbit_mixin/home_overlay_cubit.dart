import 'package:bank/app/design/theme/app_theme.dart';
import 'package:bank/core/base/cubit/base_cubit.dart';

import '../../../cubit/wallet_animation_state.dart';

/// Mixin that provides Dynamic Island drag and expand/collapse logic for [WalletAnimationState].
/// Use from a [SubView] that displays the overlay; call [onIslandDragUpdate], [onIslandDragEnd], [closeIsland].
mixin HomeOverlayCubitMixin on BaseCubit<WalletAnimationState> {
  static const Duration _snapDuration = Duration(milliseconds: 400);

  /// Call from GestureDetector.onVerticalDragUpdate. [screenHeight] from MediaQuery.sizeOf(context).height.
  void onIslandDragUpdate(double deltaDy, double screenHeight) {
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final current = state.islandState;
    final newHeight = (current.height + deltaDy).clamp(
      AppSpacing.islandStartHeight,
      endHeight,
    );
    final progress = _islandProgressFromHeight(newHeight, screenHeight);
    emit(state.copyWith(
      islandState: current.copyWith(height: newHeight, progress: progress),
    ));
  }

  /// Call from GestureDetector.onVerticalDragEnd. [velocityDy] from details.velocity.pixelsPerSecond.dy.
  void onIslandDragEnd(double velocityDy, double screenHeight) {
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final threshold = (AppSpacing.islandStartHeight + endHeight) / 2;
    final currentHeight = state.islandState.height;
    final shouldExpand = velocityDy > 500 || currentHeight > threshold;
    final targetHeight =
        shouldExpand ? endHeight : AppSpacing.islandStartHeight;
    final targetProgress = _islandProgressFromHeight(targetHeight, screenHeight);

    Future.delayed(_snapDuration, () {
      if (!isClosed) {
        emit(state.copyWith(
          islandState: state.islandState.copyWith(
            height: targetHeight,
            progress: targetProgress,
          ),
        ));
      }
    });
  }

  /// Collapse the island (e.g. from BlobContent onClose).
  void closeIsland() {
    Future.delayed(_snapDuration, () {
      if (!isClosed) {
        emit(state.copyWith(
          islandState: const IslandState(
            height: AppSpacing.islandStartHeight,
            progress: 0.0,
          ),
        ));
      }
    });
  }

  double _islandProgressFromHeight(double height, double screenHeight) {
    final endHeight = screenHeight - AppSpacing.islandBottomMargin;
    final startHeight = AppSpacing.islandStartHeight;
    final range = (endHeight - startHeight).clamp(1.0, double.infinity);
    return ((height - startHeight) / range).clamp(0.0, 1.0);
  }
}
