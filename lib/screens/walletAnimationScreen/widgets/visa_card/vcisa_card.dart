import 'package:bank/app/design/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Visa-style card with flip animation and wet-paint shimmer (from example).
class VcisaCard extends StatefulWidget {
  const VcisaCard({super.key});

  @override
  State<VcisaCard> createState() => _VcisaCardState();
}

class _VcisaCardState extends State<VcisaCard> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _shimmerController;
  double _rotation = 0.0;
  double _dragStartFace = 0.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      final direction = _isBackVisible() ? -1.0 : 1.0;
      final current = _rotation;
      final angleInHalfTurn = ((current - _dragStartFace) % 180 + 180) % 180;
      final distanceFromMid = (angleInHalfTurn - 90).abs();
      final magneticFactor = _lerp(0.25, 1.0, (distanceFromMid / 90).clamp(0.0, 1.0));
      final proposed = current + details.primaryDelta! * 0.6 * magneticFactor * direction;
      _rotation = proposed.clamp(_dragStartFace - 180, _dragStartFace + 180);
    });
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartFace = (_rotation / 180).roundToDouble() * 180;
  }

  void _onDragEnd(DragEndDetails details) {
    final current = _rotation;
    final base = _dragStartFace;
    final offset = current - base;
    final velocity = details.velocity.pixelsPerSecond.dx;

    double target;
    if (velocity > 800) {
      target = base + 180;
    } else if (velocity < -800) {
      target = base - 180;
    } else if (offset > 60) {
      target = base + 180;
    } else if (offset < -60) {
      target = base - 180;
    } else {
      target = base;
    }

    final startRotation = _rotation;
    _rotationController.reset();
    final animation = Tween<double>(
      begin: startRotation,
      end: target,
    ).animate(CurvedAnimation(parent: _rotationController, curve: Curves.easeOut));

    animation.addListener(() {
      setState(() {
        _rotation = animation.value;
      });
    });

    _rotationController.forward();
  }

  bool _isBackVisible() {
    final normalizedAngle = (_rotation % 360 + 360) % 360;
    return normalizedAngle >= 90 && normalizedAngle <= 270;
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardHeight = (screenWidth * 0.55).clamp(200.0, 240.0);

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragEnd: _onDragEnd,
      child: SizedBox(
        height: cardHeight,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_rotation * 3.14159 / 180),
          child: _isBackVisible()
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(3.14159),
                  child: _VcisaCardBack(height: cardHeight),
                )
              : _VcisaCardFront(shimmerPhase: _shimmerController.value, height: cardHeight),
        ),
      ),
    );
  }
}

class _VcisaCardFront extends StatelessWidget {
  final double shimmerPhase;
  final double height;

  const _VcisaCardFront({required this.shimmerPhase, required this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
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
            CustomPaint(size: Size.infinite, painter: _BackgroundOverlayPainter()),
            CustomPaint(
              size: Size.infinite,
              painter: _PaintPathPainter(shimmerPhase: shimmerPhase),
            ),
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
                                'NEXUS',
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
                          'VIRTUAL',
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
                              '••',
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
                                '1234',
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
                          'VISA',
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

class _VcisaCardBack extends StatelessWidget {
  final double height;

  const _VcisaCardBack({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.platinumBase, AppColors.platinumDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 0),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF303030),
                        Colors.black,
                        Colors.black,
                        const Color(0xFF303030),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          padding: const EdgeInsets.only(left: 12),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Authorized Signature',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Text(
                            'CVC',
                            style: TextStyle(
                              color: AppColors.spaceStart.withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 64,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '892',
                              style: TextStyle(
                                color: AppColors.electricAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARD HOLDER',
                        style: TextStyle(
                          color: AppColors.spaceStart.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'KYRIAKOS GEORGIOPOULOS',
                        style: TextStyle(
                          color: AppColors.spaceStart,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundOverlayPainter extends CustomPainter {
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

class _PaintPathPainter extends CustomPainter {
  final double shimmerPhase;

  _PaintPathPainter({required this.shimmerPhase});

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
        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
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
        colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
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
    return oldDelegate is! _PaintPathPainter || oldDelegate.shimmerPhase != shimmerPhase;
  }
}
