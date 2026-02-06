import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/balance_section.dart';
import '../widgets/blob_content.dart';
import '../widgets/transactions_list.dart';
import '../widgets/wet_paint_card/wet_paint_card.dart';

enum BlobState { collapsed, expanded }

class HomeContent extends StatefulWidget {
  final double topPadding;
  final VoidCallback onProfileClick;
  final double progress;
  final ValueChanged<double> onIslandProgress;

  const HomeContent({
    super.key,
    required this.topPadding,
    required this.onProfileClick,
    required this.progress,
    required this.onIslandProgress,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _islandController;
  double _islandHeight = AppConstants.islandStartHeight;
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
    final screenHeight = MediaQuery.of(context).size.height;
    final endHeight = screenHeight - 96;
    final startHeight = AppConstants.islandStartHeight;
    final progress = ((height - startHeight) / (endHeight - startHeight)).clamp(0.0, 1.0);

    setState(() {
      _islandProgress = progress;
    });
    widget.onIslandProgress(_islandProgress);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final endHeight = screenHeight - 96;
    final newHeight = (_islandHeight + details.delta.dy).clamp(
      AppConstants.islandStartHeight,
      endHeight,
    );

    setState(() {
      _islandHeight = newHeight;
    });
    _updateIslandProgress(newHeight);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final endHeight = screenHeight - 96;
    final threshold = (AppConstants.islandStartHeight + endHeight) / 2;
    final velocity = details.velocity.pixelsPerSecond.dy;

    final shouldExpand = velocity > 500 || _islandHeight > threshold;
    final targetHeight = shouldExpand ? endHeight : AppConstants.islandStartHeight;

    _islandController.reset();
    _islandController.forward().then((_) {
      setState(() {
        _islandHeight = targetHeight;
      });
      _updateIslandProgress(targetHeight);
    });
  }

  void _closeIsland() {
    _islandController.reset();
    _islandController.forward().then((_) {
      setState(() {
        _islandHeight = AppConstants.islandStartHeight;
      });
      _updateIslandProgress(AppConstants.islandStartHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final endWidth = screenWidth - 32;

    // Calculate width and radius with easing
    final widthProgress = _cubicBezierEasing(_islandProgress);
    final currentWidth = _lerp(AppConstants.islandStartWidth, endWidth, widthProgress);
    final currentRadius = _lerp(
      AppConstants.islandStartRadius,
      AppConstants.islandEndRadius,
      widthProgress,
    );

    final smoothProgress = _islandProgress;

    return Container(
      color: const Color(0xFFF1F5F9),
      child: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: widget.topPadding + AppConstants.islandStartHeight + 24,
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const WetPaintCard(),
                const SizedBox(height: 32),
                const BalanceSection(),
                const SizedBox(height: 48),
                SizedBox(height: 400, child: const TransactionsList()),
              ],
            ),
          ),

          // Profile button (only when progress is 0)
          if (widget.progress == 0)
            Positioned(
              top: widget.topPadding + 2,
              left: 24,
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
                          color: AppColors.electricAccent.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Add money button
          Positioned(
            top: widget.topPadding + 2,
            right: 24,
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
                  border: Border.all(color: AppColors.electricAccent.withOpacity(0.5), width: 1),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Dynamic Island
          Positioned(
            top: widget.topPadding,
            left: (screenWidth - currentWidth) / 2,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                width: currentWidth,
                height: _islandHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(currentRadius),
                  gradient: const LinearGradient(
                    colors: [AppColors.spaceStart, AppColors.spaceEnd],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(width: 1, color: AppColors.electricAccent.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.8 * smoothProgress),
                      blurRadius: smoothProgress * 40,
                      spreadRadius: smoothProgress * 5,
                    ),
                    BoxShadow(
                      color: const Color(0xFFC084FC).withOpacity(0.8 * smoothProgress),
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
        ],
      ),
    );
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  double _cubicBezierEasing(double t) {
    // CubicBezier(0.4, 0.0, 0.2, 1.0)
    return t * t * (3.0 - 2.0 * t);
  }
}
