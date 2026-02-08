part of '../../wallet_animation_screen.dart';

class _TransactionsCard extends SubView<WalletAnimationCubit> {
  const _TransactionsCard();

  @override
  Widget build(BuildContext context) => Container(
    margin: .only(top: AppSpacing.giant),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppBorderRadius.xxxLarge)),
      border: .fromBorderSide(
        BorderSide(color: AppColors.platinumDark.withValues(alpha: 0.25), width: 1),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const .new(0, -4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: .stretch,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const .fromLTRB(0, AppSpacing.md, 0, AppSpacing.sm),
          child: Padding(
            padding: const .symmetric(horizontal: AppSpacing.screenHorizontal),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Recent transactions',
                  style: AppTextStyles.transactionTitle.copyWith(color: AppColors.black),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: .zero,
                    padding: .zero,
                    tapTargetSize: .shrinkWrap,
                  ),
                  child: Text(
                    'See all',
                    style: AppTextStyles.transactionSubtitle.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          indent: 0,
          endIndent: 0,
        ),
        BlocSelector<WalletAnimationCubit, WalletAnimationState, TransactionStatus>(
          selector: (state) => state.status!,
          builder: (context, status) {
            final list = cubit.state.transactions;
            return Expanded(
              child: status == .empty
                  ? const _EmptyTransactions()
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        top: AppSpacing.sm,
                        bottom: AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                        indent: 48 + AppSpacing.lg,
                        endIndent: 0,
                      ),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenHorizontal,
                        ),
                        child: TransactionItem(
                          transaction: list[index],
                        ).redacted(context: context, redact: status == .loading),
                      ),
                    ),
            );
          },
        ),
      ],
    ),
  );
}
