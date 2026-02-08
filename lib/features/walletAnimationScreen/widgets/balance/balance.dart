part of '../../wallet_animation_screen.dart';

/// Balance section wrapped in a subtle card (rounded corners, surface background). Do not change color/style.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final num balance;

  @override
  Widget build(BuildContext context) => Container(
    width: .infinity,
    padding: .symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
    margin: .symmetric(horizontal: AppSpacing.xxl),
    decoration: BoxDecoration(
      gradient: AppGradients.cardBackBackground,
      borderRadius: .circular(AppBorderRadius.lg),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const .new(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const .new(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          'Your Balance',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: .w500),
        ),
        Center(
          child: FittedBox(
            fit: .scaleDown,
            child: Text(
              '\$${balance.toDouble().toStringAsFixed(2)}',
              style: AppTextStyles.balanceAmount.copyWith(color: AppColors.spaceStart),
            ),
          ),
        ),
      ],
    ),
  );
}
