import 'package:flutter/material.dart';

import '../../../../../app/design/colors/app_colors.dart';

class VisaCardPainter extends CustomPainter {
  final double shimmerPhase;

  VisaCardPainter({required this.shimmerPhase});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    if (width <= 0 || height <= 0 || !width.isFinite || !height.isFinite) {
      return;
    }

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

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..shader = LinearGradient(
        colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, height * 0.1, width, height));

    canvas.drawPath(paintPath, strokePaint);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.spaceStart, AppColors.spaceEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(paintPath, fillPaint);

    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
        center: const Alignment(0.2, 0.8),
        radius: width * 0.5,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(paintPath, shadowPaint);

    canvas.save();
    canvas.clipPath(paintPath);
    final shimmerStart = -width + (width * 3 * shimmerPhase);
    final shimmerEnd = shimmerStart + width * 0.5;

    final startX = (shimmerStart / width).clamp(-2.0, 2.0);
    final endX = (shimmerEnd / width).clamp(-2.0, 2.0);

    if (startX.isFinite && endX.isFinite) {
      final shimmerPaint = Paint()
        ..shader = LinearGradient(
          colors: [Colors.transparent, Colors.white.withValues(alpha: 0.15), Colors.transparent],
          begin: Alignment(startX, -1),
          end: Alignment(endX, 1),
        ).createShader(Rect.fromLTWH(0, 0, width, height));

      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), shimmerPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! VisaCardPainter || oldDelegate.shimmerPhase != shimmerPhase;
  }
}
