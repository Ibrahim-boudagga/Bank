import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class WetPaintCardFront extends StatelessWidget {
  final double shimmerPhase;
  final double height;

  const WetPaintCardFront({super.key, required this.shimmerPhase, required this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
    final nexusFontSize = (screenWidth * 0.055).clamp(18.0, 22.0) * textScale;
    final virtualFontSize = (screenWidth * 0.025).clamp(8.0, 10.0) * textScale;
    final dotsFontSize = (screenWidth * 0.06).clamp(20.0, 24.0) * textScale;
    final cardNumberFontSize = (screenWidth * 0.05).clamp(16.0, 20.0) * textScale;
    final visaFontSize = (screenWidth * 0.07).clamp(24.0, 28.0) * textScale;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.platinumBase, AppColors.platinumDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 0),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background overlay
            CustomPaint(size: Size.infinite, painter: BackgroundOverlayPainter()),
            // Paint path
            CustomPaint(
              size: Size.infinite,
              painter: PaintPathPainter(shimmerPhase: shimmerPhase),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "NEXUS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: nexusFontSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "VIRTUAL",
                          style: TextStyle(
                            color: AppColors.silverText,
                            fontSize: virtualFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "••",
                              style: TextStyle(
                                color: AppColors.electricAccent,
                                fontSize: dotsFontSize,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6, bottom: 2),
                              child: Text(
                                "1234",
                                style: TextStyle(
                                  color: AppColors.spaceStart,
                                  fontSize: cardNumberFontSize,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "VISA",
                          style: TextStyle(
                            color: AppColors.spaceStart,
                            fontWeight: FontWeight.w900,
                            fontSize: visaFontSize,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -1,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || !size.width.isFinite || !size.height.isFinite) {
      return;
    }

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.black, Colors.transparent],
        radius: size.width,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..blendMode = BlendMode.overlay;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint..color = Colors.black.withOpacity(0.08),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PaintPathPainter extends CustomPainter {
  final double shimmerPhase;

  PaintPathPainter({required this.shimmerPhase});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Guard against invalid sizes
    if (width <= 0 || height <= 0 || !width.isFinite || !height.isFinite) {
      return;
    }

    // Create paint path
    final paintPath = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height * 0.15)
      ..cubicTo(
        width * 0.96,
        height * 0.15,
        width * 0.94,
        height * 0.20,
        width * 0.92,
        height * 0.50,
      )
      ..cubicTo(
        width * 0.90,
        height * 0.65,
        width * 0.84,
        height * 0.65,
        width * 0.82,
        height * 0.40,
      )
      ..cubicTo(
        width * 0.78,
        height * 0.25,
        width * 0.72,
        height * 0.25,
        width * 0.68,
        height * 0.60,
      )
      ..cubicTo(
        width * 0.66,
        height * 0.92,
        width * 0.56,
        height * 0.92,
        width * 0.54,
        height * 0.60,
      )
      ..cubicTo(
        width * 0.50,
        height * 0.30,
        width * 0.45,
        height * 0.30,
        width * 0.42,
        height * 0.70,
      )
      ..cubicTo(
        width * 0.40,
        height * 0.85,
        width * 0.30,
        height * 0.85,
        width * 0.28,
        height * 0.55,
      )
      ..cubicTo(
        width * 0.25,
        height * 0.25,
        width * 0.20,
        height * 0.25,
        width * 0.18,
        height * 0.45,
      )
      ..cubicTo(
        width * 0.16,
        height * 0.55,
        width * 0.10,
        height * 0.55,
        width * 0.08,
        height * 0.35,
      )
      ..cubicTo(width * 0.04, height * 0.15, 0, height * 0.20, 0, height * 0.15)
      ..close();

    // Draw paint path stroke
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..shader = LinearGradient(
        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, height * 0.1, width, height));

    canvas.drawPath(paintPath, strokePaint);

    // Draw paint fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.spaceStart, AppColors.spaceEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(paintPath, fillPaint);

    // Draw radial shadow
    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
        center: Alignment(0.2, 0.8),
        radius: width * 0.5,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(paintPath, shadowPaint);

    // Draw shimmer effect
    canvas.save();
    canvas.clipPath(paintPath);
    final shimmerStart = -width + (width * 3 * shimmerPhase);
    final shimmerEnd = shimmerStart + width * 0.5;

    // Normalize positions for Alignment (values between -1 and 1)
    final startX = (shimmerStart / width).clamp(-2.0, 2.0);
    final endX = (shimmerEnd / width).clamp(-2.0, 2.0);

    // Ensure values are finite
    if (startX.isFinite && endX.isFinite) {
      final shimmerPaint = Paint()
        ..shader = LinearGradient(
          colors: [Colors.transparent, Colors.white.withOpacity(0.15), Colors.transparent],
          begin: Alignment(startX, -1),
          end: Alignment(endX, 1),
        ).createShader(Rect.fromLTWH(0, 0, width, height));

      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), shimmerPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! PaintPathPainter || oldDelegate.shimmerPhase != shimmerPhase;
  }
}
