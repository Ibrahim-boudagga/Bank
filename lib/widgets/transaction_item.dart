import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../theme/app_colors.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    final titleFontSize = (screenWidth * 0.04).clamp(14.0, 16.0) * textScale;
    final subtitleFontSize = (screenWidth * 0.03).clamp(10.0, 12.0) * textScale;
    final amountFontSize = (screenWidth * 0.04).clamp(14.0, 16.0) * textScale;
    final iconSize = (screenWidth * 0.06).clamp(20.0, 24.0);
    final containerSize = (screenWidth * 0.12).clamp(40.0, 48.0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(transaction.icon, color: transaction.iconColor, size: iconSize),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    color: AppColors.spaceStart,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Text(
            transaction.amount,
            style: TextStyle(
              color: transaction.isPositive ? AppColors.successDark : AppColors.spaceStart,
              fontSize: amountFontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
