import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../screens/home_content.dart';
import '../screens/profile_screen_content.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_profile_avatar.dart';

class WalletAnimationScreen extends StatefulWidget {
  const WalletAnimationScreen({super.key});

  @override
  State<WalletAnimationScreen> createState() => _WalletAnimationScreenState();
}

class _WalletAnimationScreenState extends State<WalletAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rollController;
  bool _isProfileOpen = false;
  double _islandExpansionProgress = 0.0;
  double _rollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _rollController = AnimationController(vsync: this, lowerBound: 0.0, upperBound: 1.0);
  }

  @override
  void dispose() {
    _rollController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    if (_rollController.isAnimating) {
      return; // Prevent multiple taps during animation
    }

    setState(() {
      _isProfileOpen = !_isProfileOpen;
    });

    final targetValue = _isProfileOpen ? 1.0 : 0.0;

    // Spring animation like in Kotlin
    // dampingRatio: 0.85f (close), 0.75f (open)
    // stiffness: 300f (close), 160f (open)
    final spring = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: _isProfileOpen ? 160.0 : 300.0,
        ratio: _isProfileOpen ? 0.75 : 0.85,
      ),
      _rollController.value,
      targetValue,
      0.0,
    );

    _rollController.animateWith(spring);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    final rollTarget = screenHeight * 0.75;

    _rollOffset = _rollController.value * rollTarget;
    final progress = (_rollOffset / rollTarget).clamp(0.0, 1.0);
    final avatarAlpha = (1.0 - (_islandExpansionProgress * 6.0)).clamp(0.0, 1.0);

    // Update status bar style
    SystemChrome.setSystemUIOverlayStyle(
      progress < 0.5 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return AnimatedBuilder(
      animation: _rollController,
      builder: (context, child) {
        return Container(
          color: AppColors.spaceEnd,
          child: Stack(
            children: [
              // Profile screen (background)
              ProfileScreenContent(
                isOpen: _isProfileOpen,
                progress: progress,
                topPadding: topPadding,
                onBack: _toggleProfile,
              ),

              // Home content (rolling foreground)
              Transform.translate(
                offset: Offset(0, _rollOffset),
                child: _buildRollingSurface(
                  context,
                  screenWidth,
                  _rollOffset,
                  progress,
                  topPadding,
                ),
              ),

              // Shared avatar (morphing)
              if (avatarAlpha > 0)
                SharedProfileAvatar(
                  progress: progress,
                  screenWidth: screenWidth,
                  topPadding: topPadding,
                  alpha: avatarAlpha,
                  onClick: _toggleProfile,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRollingSurface(
    BuildContext context,
    double screenWidth,
    double rollPx,
    double progress,
    double topPadding,
  ) {
    if (rollPx <= 1.0) {
      return HomeContent(
        topPadding: topPadding,
        onProfileClick: _toggleProfile,
        progress: progress,
        onIslandProgress: (value) {
          setState(() {
            _islandExpansionProgress = value;
          });
        },
      );
    }

    final cylinderDiameter = (math.sqrt(rollPx) * 3.6).clamp(1.0, double.infinity);

    return Stack(
      children: [
        // Main content
        HomeContent(
          topPadding: topPadding,
          onProfileClick: _toggleProfile,
          progress: progress,
          onIslandProgress: (value) {
            setState(() {
              _islandExpansionProgress = value;
            });
          },
        ),

        // Cylinder shadow effect
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: cylinderDiameter * 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Cylinder surface
        Positioned(
          top: -cylinderDiameter,
          left: 0,
          right: 0,
          child: Container(
            height: cylinderDiameter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD1D5DB),
                  Colors.white,
                  const Color(0xFFE5E7EB),
                  const Color(0xFF9CA3AF),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
