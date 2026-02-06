import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../theme/app_colors.dart';
import '../widgets/transaction_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    final titleFontSize = (screenWidth * 0.045).clamp(16.0, 18.0) * textScale;
    final seeAllFontSize = (screenWidth * 0.035).clamp(12.0, 14.0) * textScale;

    final transactions = [
      const Transaction(
        icon: Icons.shopping_cart,
        title: "Whole Foods Market",
        subtitle: "Groceries • Today",
        amount: "-\$124.50",
      ),
      const Transaction(
        icon: Icons.movie,
        title: "Netflix Subscription",
        subtitle: "Entertainment • Yesterday",
        amount: "-\$15.99",
      ),
      const Transaction(
        icon: Icons.bolt,
        title: "Electric Bill",
        subtitle: "Utilities • Feb 12",
        amount: "-\$85.00",
      ),
      const Transaction(
        icon: Icons.attach_money,
        title: "Salary Deposit",
        subtitle: "Income • Feb 01",
        amount: "+\$4,250.00",
        isPositive: true,
      ),
      const Transaction(
        icon: Icons.directions_car,
        title: "Uber Ride",
        subtitle: "Transport • Jan 30",
        amount: "-\$24.20",
      ),
      const Transaction(
        icon: Icons.phone_iphone,
        title: "Apple Store",
        subtitle: "Electronics • Jan 28",
        amount: "-\$999.00",
      ),
      const Transaction(
        icon: Icons.fitness_center,
        title: "Equinox Gym",
        subtitle: "Health • Jan 25",
        amount: "-\$180.00",
      ),
      const Transaction(
        icon: Icons.music_note,
        title: "Spotify Premium",
        subtitle: "Subscription • Jan 24",
        amount: "-\$12.99",
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "Recent Transactions",
                style: TextStyle(
                  color: AppColors.spaceStart,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "See All",
              style: TextStyle(
                color: AppColors.electricAccent,
                fontSize: seeAllFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(transaction: transactions[index]);
            },
          ),
        ),
      ],
    );
  }
}
