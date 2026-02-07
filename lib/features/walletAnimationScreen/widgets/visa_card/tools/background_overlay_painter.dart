import 'package:flutter/material.dart';

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
      ..blendMode = .overlay;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint..color = Colors.black.withValues(alpha: 0.08),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
