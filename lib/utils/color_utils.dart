import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Color getRandomColor(int index) {
  return AppColors.avatarColors[index % AppColors.avatarColors.length];
}
