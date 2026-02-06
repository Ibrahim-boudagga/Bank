import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

class BalanceSection extends StatefulWidget {
  const BalanceSection({super.key});

  @override
  State<BalanceSection> createState() => _BalanceSectionState();
}

class _BalanceSectionState extends State<BalanceSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -100,
      end: 400,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    final balanceFontSize = (screenWidth * 0.08).clamp(24.0, 34.0) * textScale;
    final labelFontSize = (screenWidth * 0.035).clamp(12.0, 14.0) * textScale;
    final badgeFontSize = (screenWidth * 0.032).clamp(11.0, 13.0) * textScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Total Balance",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppConstants.balance,
                style: TextStyle(
                  color: AppColors.spaceStart,
                  fontSize: balanceFontSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.successDark.withOpacity(0.1),
                      width: 1,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFDCFCE7),
                        const Color(0xFFF0FDF4),
                        const Color(0xFFDCFCE7),
                      ],
                      begin: Alignment(_shimmerAnimation.value / 100 - 1, 0),
                      end: Alignment(_shimmerAnimation.value / 100, 1),
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: AppColors.successDark,
                        size: badgeFontSize,
                      ),
                      SizedBox(width: screenWidth * 0.005),
                      Text(
                        AppConstants.balanceChange,
                        style: TextStyle(
                          color: AppColors.successDark,
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
