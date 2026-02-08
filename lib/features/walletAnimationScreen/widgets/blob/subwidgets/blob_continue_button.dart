import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Continue button with scale/opacity driven by progress.
class BlobContinueButton extends StatelessWidget {
  const BlobContinueButton({
    super.key,
    required this.screenWidth,
    required this.buttonScale,
  });

  final double screenWidth;
  final double buttonScale;

  @override
  Widget build(BuildContext context) {
    final buttonFontSize = (screenWidth * 0.042).clamp(15.0, 17.0);

    return Transform.scale(
      scale: buttonScale,
      child: Opacity(
        opacity: buttonScale,
        child: SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.specularWhite,
              foregroundColor: AppColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.button),
              ),
            ),
            child: Text(
              'Continue',
              style: AppTextStyles.islandButton.copyWith(fontSize: buttonFontSize),
            ),
          ),
        ),
      ),
    );
  }
}
