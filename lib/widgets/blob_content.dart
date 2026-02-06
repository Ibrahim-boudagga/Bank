import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/color_utils.dart';
import '../utils/constants.dart';
import 'contact_circle.dart';

class BlobContent extends StatelessWidget {
  final double progress;
  final VoidCallback onClose;

  const BlobContent({super.key, required this.progress, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    final titleFontSize = (screenWidth * 0.05).clamp(18.0, 20.0) * textScale;
    final largeTitleFontSize = (screenWidth * 0.085).clamp(28.0, 34.0) * textScale;
    final pillFontSize = (screenWidth * 0.04).clamp(14.0, 16.0) * textScale;
    final contactNameFontSize = (screenWidth * 0.03).clamp(10.0, 12.0) * textScale;
    final sectionTitleFontSize = (screenWidth * 0.05).clamp(18.0, 20.0) * textScale;
    final contactItemFontSize = (screenWidth * 0.04).clamp(14.0, 16.0) * textScale;
    final contactSubtitleFontSize = (screenWidth * 0.03).clamp(10.0, 12.0) * textScale;
    final buttonFontSize = (screenWidth * 0.042).clamp(15.0, 17.0) * textScale;

    final pillAlpha = progress < 0.5 ? (1.0 - (progress * 5.0)).clamp(0.0, 1.0) : 0.0;

    final contentAlpha = ((progress - 0.2) / 0.4).clamp(0.0, 1.0);
    final contentParallax = (1.0 - progress) * 100.0;
    final bubbleScale = (progress * 1.2).clamp(0.0, 1.0);
    final buttonScale = (progress * 1.5 - 0.5).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Pill content (collapsed state)
        if (pillAlpha > 0)
          Opacity(
            opacity: pillAlpha,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Send",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: pillFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          "to",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: pillFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          Transform.translate(
                            offset: Offset(i > 0 ? -8.0 * i : 0, 0),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getRandomColor(i),
                                border: Border.all(color: AppColors.spaceStart, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  ["A", "S", "J"][i],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Expanded content
        Transform.translate(
          offset: Offset(0, contentParallax),
          child: Opacity(
            opacity: contentAlpha,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Send",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: titleFontSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Money To",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: largeTitleFontSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(Icons.close, color: AppColors.textPrimary),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.glassSurface,
                          shape: const CircleBorder(),
                          side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Transform.scale(
                            scale: bubbleScale,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: AppConstants.contactNames.length + 1, // +1 for Add button
                              itemBuilder: (context, index) {
                                if (index < AppConstants.contactNames.length) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: index < AppConstants.contactNames.length - 1 ? 16 : 0,
                                    ),
                                    child: ContactCircle(
                                      name: AppConstants.contactNames[index],
                                      color: AppConstants.contactColors[index],
                                    ),
                                  );
                                } else {
                                  // Add button
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0.05),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Add",
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: contactNameFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Your Contacts",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: sectionTitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: AppConstants.transactionNames.length,
                      itemBuilder: (context, index) {
                        final start = 0.4 + (index * 0.05);
                        final end = 1.0;
                        final itemProgress = ((progress - start) / (end - start)).clamp(0.0, 1.0);
                        final itemScale = _lerp(0.8, 1.0, itemProgress);
                        final itemAlpha = itemProgress;
                        final itemTranslationY = (1.0 - itemProgress) * 100.0;

                        return Transform.translate(
                          offset: Offset(0, itemTranslationY),
                          child: Transform.scale(
                            scale: itemScale,
                            child: Opacity(
                              opacity: itemAlpha,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.glassSurface,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: getRandomColor(index),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppConstants.transactionInitials[index],
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.6),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppConstants.transactionNames[index],
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: contactItemFontSize,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "Recent transfer",
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: contactSubtitleFontSize,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.textSecondary.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Transform.scale(
                    scale: buttonScale,
                    child: Opacity(
                      opacity: buttonScale,
                      child: SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          ),
                          child: Text(
                            "Continue",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: buttonFontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }
}
