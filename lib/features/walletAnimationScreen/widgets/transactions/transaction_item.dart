import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../models/transaction.dart';

/// Single row for a transaction in the recent transactions list.
class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(vertical: AppSpacing.transactionItemSpacing),
    child: Row(
      crossAxisAlignment: .center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.spaceStart,
            borderRadius: .circular(AppBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const .new(0, 1),
              ),
            ],
          ),
          child: Icon(transaction.icon, color: AppColors.textPrimary, size: 24),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                transaction.title,
                style: AppTextStyles.transactionTitle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                transaction.subtitle,
                style: AppTextStyles.transactionLabel.copyWith(color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Text(
          transaction.amount.toString(),
          style: AppTextStyles.transactionAmount.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: transaction.amount > 0 ? AppColors.black : AppColors.errorRed,
          ),
          textAlign: TextAlign.right,
        ),
      ],
    ),
  );
}
