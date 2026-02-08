part of '../../wallet_animation_screen.dart';

/// Collapsing header: Visa card "slides under" the bar with a subtle 3D tilt and soft fade.
/// No harsh translate – the card stays at the bottom of the flexible space and gets
/// clipped naturally as the bar collapses, with perspective and gradient for a premium feel.
class _WalletCard extends StatelessWidget {
  const _WalletCard();

  @override
  Widget build(BuildContext context) => Stack(
    fit: .expand,
    children: [
      Positioned(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        bottom: AppSpacing.xxl,
        child: const VisaCard(),
      ),
    ],
  );
}
