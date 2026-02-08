part of '../../wallet_animation_screen.dart';

/// Full-width sheet under the balance card. Curved top, sits visually below the balance (stack).
class _TransactionsCard extends StatelessWidget {
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
          padding: EdgeInsets.fromLTRB(0, AppSpacing.md, 0, AppSpacing.sm),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Recent transactions',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        // Only the list scrolls
        Expanded(
          child: ListView.separated(
            padding: .only(
              top: AppSpacing.sm,
              bottom: AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: _defaultTransactionsForSliver.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              indent: 48 + AppSpacing.lg,
              endIndent: 0,
            ),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: TransactionItem(transaction: _defaultTransactionsForSliver[index]),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Default transaction list for the wallet slivers (same as [TransactionsSection]).
List<Transaction> get _defaultTransactionsForSliver => _defaultTransactionsList;
final List<Transaction> _defaultTransactionsList = [
  const Transaction(
    icon: Icons.shopping_cart_outlined,
    title: 'Whole Foods Market',
    subtitle: 'Groceries • Today',
    amount: '-\$124.50',
  ),
  const Transaction(
    icon: Icons.movie_outlined,
    title: 'Netflix',
    subtitle: 'Entertainment • Yesterday',
    amount: '-\$15.99',
  ),
  const Transaction(
    icon: Icons.bolt_outlined,
    title: 'Electric Bill',
    subtitle: 'Utilities • Feb 12',
    amount: '-\$85.00',
  ),
  const Transaction(
    icon: Icons.account_balance_wallet_outlined,
    title: 'Salary Deposit',
    subtitle: 'Income • Feb 01',
    amount: '+\$4,250.00',
    isPositive: true,
  ),
  const Transaction(
    icon: Icons.directions_car_outlined,
    title: 'Uber Ride',
    subtitle: 'Transport • Jan 30',
    amount: '-\$24.20',
  ),
  const Transaction(
    icon: Icons.phone_iphone_outlined,
    title: 'Apple Store',
    subtitle: 'Electronics • Jan 28',
    amount: '-\$999.00',
  ),
  const Transaction(
    icon: Icons.shopping_cart_outlined,
    title: 'Whole Foods Market',
    subtitle: 'Groceries • Today',
    amount: '-\$124.50',
  ),
  const Transaction(
    icon: Icons.movie_outlined,
    title: 'Netflix',
    subtitle: 'Entertainment • Yesterday',
    amount: '-\$15.99',
  ),
  const Transaction(
    icon: Icons.bolt_outlined,
    title: 'Electric Bill',
    subtitle: 'Utilities • Feb 12',
    amount: '-\$85.00',
  ),
  const Transaction(
    icon: Icons.account_balance_wallet_outlined,
    title: 'Salary Deposit',
    subtitle: 'Income • Feb 01',
    amount: '+\$4,250.00',
    isPositive: true,
  ),
  const Transaction(
    icon: Icons.directions_car_outlined,
    title: 'Uber Ride',
    subtitle: 'Transport • Jan 30',
    amount: '-\$24.20',
  ),
  const Transaction(
    icon: Icons.phone_iphone_outlined,
    title: 'Apple Store',
    subtitle: 'Electronics • Jan 28',
    amount: '-\$999.00',
  ),
];
