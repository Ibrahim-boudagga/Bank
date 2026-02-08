part of '../../wallet_animation_screen.dart';

/// Collapsing header: Visa card "slides under" the bar with a subtle 3D tilt and soft fade.
/// No harsh translate – the card stays at the bottom of the flexible space and gets
/// clipped naturally as the bar collapses, with perspective and gradient for a premium feel.
class _WalletFlexibleSpace extends StatelessWidget {
  const _WalletFlexibleSpace({required this.overlayHeight});

  final double overlayHeight;

  static const double _cardAreaHeight = 280.0;

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded = overlayHeight + _cardAreaHeight;
        final maxHeight = constraints.maxHeight;
        final range = (expanded - overlayHeight).clamp(1.0, double.infinity);
        final progress = maxHeight >= expanded - 2
            ? 1.0
            : ((maxHeight - overlayHeight) / range).clamp(0.0, 1.0);

        // 3D tilt: card tilts backward (into the screen) as it slides under. ~0° when expanded, ~10° when collapsed.
        final tiltRad = (1 - progress) * 0.18;
        final scale = 0.96 + 0.04 * progress;

        return Stack(
          fit: .expand,
          children: [
            // Soft gradient so the card fades into the header (no hard cut)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [scaffoldColor, scaffoldColor.withValues(alpha: 0.0)],
                    ),
                  ),
                ),
              ),
            ),
            // Card: anchored at bottom, scales and tilts as it slides under (no translate)
            Positioned(
              left: AppSpacing.screenHorizontal,
              right: AppSpacing.screenHorizontal,
              bottom: AppSpacing.xxl,
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(tiltRad),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.bottomCenter,
                  child: const VisaCard(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
