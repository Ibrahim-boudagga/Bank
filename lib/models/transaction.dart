import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Transaction {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;
  final Color iconColor;

  const Transaction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isPositive = false,
    this.iconColor = AppColors.spaceStart,
  });
}
