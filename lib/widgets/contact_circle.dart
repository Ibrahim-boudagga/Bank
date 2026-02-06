import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ContactCircle extends StatelessWidget {
  final String name;
  final Color color;

  const ContactCircle({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 28,
              ),
            ),
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.onlineGreen,
                border: Border.all(
                  color: AppColors.spaceEnd,
                  width: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
