import 'package:bank/app/design/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// A single transaction row for the recent transactions list.
class Transaction {
  const Transaction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final num amount;
  final Color? iconColor;

  Color get effectiveIconColor => iconColor ?? AppColors.spaceStart;
}
