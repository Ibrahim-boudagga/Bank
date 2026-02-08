import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// "Your Contacts" section title.
class BlobSectionTitle extends StatelessWidget {
  const BlobSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Your Contacts',
      style: AppTextStyles.islandSectionTitle.copyWith(color: AppColors.textPrimary),
    );
  }
}
