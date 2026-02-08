part of '../../wallet_animation_screen.dart';

/// Paints a large cloud with an empty folder inside (body + open flap). Light blue-green tint.
class _EmptyTransactionsPainter extends CustomPainter {
  _EmptyTransactionsPainter({
    required this.cloudColor,
    required this.folderColor,
    required this.folderEdgeColor,
  });

  final Color cloudColor;
  final Color folderColor;
  final Color folderEdgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Bigger cloud: more overlapping circles for a larger, softer shape
    final cloudPaint = Paint()..color = cloudColor;
    const r1 = 56.0;
    const r2 = 48.0;
    const r3 = 52.0;
    const r4 = 44.0;
    canvas.drawCircle(Offset(centerX - 28, centerY - 16), r1, cloudPaint);
    canvas.drawCircle(Offset(centerX + 32, centerY - 20), r2, cloudPaint);
    canvas.drawCircle(Offset(centerX + 8, centerY + 20), r3, cloudPaint);
    canvas.drawCircle(Offset(centerX - 24, centerY + 12), r4, cloudPaint);

    // Empty folder inside the cloud: body (rounded rect) + open flap (trapezoid)
    final folderCenterX = centerX;
    final folderCenterY = centerY;
    const folderW = 64.0;
    const folderH = 52.0;
    final folderLeft = folderCenterX - folderW / 2;
    final folderTop = folderCenterY - folderH / 2;

    // Folder body (back part, slightly darker edge)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(folderLeft, folderTop + 8, folderW, folderH - 8),
      const Radius.circular(6),
    );
    final bodyPaint = Paint()..color = folderColor;
    canvas.drawRRect(bodyRect, bodyPaint);
    final bodyStroke = Paint()
      ..color = folderEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(bodyRect, bodyStroke);

    // Open flap (trapezoid folded back)
    final flapPath = Path()
      ..moveTo(folderLeft + 6, folderTop + 8)
      ..lineTo(folderLeft + folderW - 6, folderTop + 8)
      ..lineTo(folderLeft + folderW - 4, folderTop + 2)
      ..lineTo(folderLeft + 4, folderTop + 2)
      ..close();
    final flapPaint = Paint()..color = folderEdgeColor.withValues(alpha: 0.4);
    canvas.drawPath(flapPath, flapPaint);
    final flapStroke = Paint()
      ..color = folderEdgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(flapPath, flapStroke);

    // Inner empty area (lighter rectangle to suggest "empty inside")
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(folderLeft + 8, folderTop + 16, folderW - 16, folderH - 24),
      const Radius.circular(4),
    );
    final innerPaint = Paint()..color = folderColor.withValues(alpha: 0.6);
    canvas.drawRRect(innerRect, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _EmptyTransactionsPainter oldDelegate) =>
      cloudColor != oldDelegate.cloudColor ||
      folderColor != oldDelegate.folderColor ||
      folderEdgeColor != oldDelegate.folderEdgeColor;
}

/// Empty state: cloud illustration with text stacked below.
class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cloudColor = isLight ? const Color(0xFFE0F2F1) : AppColors.accent.withValues(alpha: 0.15);
    final folderColor = isLight
        ? AppColors.platinumBase
        : AppColors.platinumDark.withValues(alpha: 0.35);
    final folderEdgeColor = isLight
        ? AppColors.platinumDark.withValues(alpha: 0.6)
        : AppColors.silverText.withValues(alpha: 0.7);

    return Column(
      mainAxisAlignment: .center,
      mainAxisSize: .min,

      children: [
        SizedBox(
          height: 200,
          width: 300,
          child: CustomPaint(
            painter: _EmptyTransactionsPainter(
              cloudColor: cloudColor,
              folderColor: folderColor,
              folderEdgeColor: folderEdgeColor,
            ),
            size: const .new(280, 200),
          ),
        ),
        Text(
          'No transactions yet',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Your recent activity will show here once you make a payment or receive money.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
