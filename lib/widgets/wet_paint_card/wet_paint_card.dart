import 'package:flutter/material.dart';

import 'wet_paint_card_back.dart';
import 'wet_paint_card_front.dart';

class WetPaintCard extends StatefulWidget {
  const WetPaintCard({super.key});

  @override
  State<WetPaintCard> createState() => _WetPaintCardState();
}

class _WetPaintCardState extends State<WetPaintCard> with TickerProviderStateMixin {
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
    final screenWidth = MediaQuery.of(context).size.width;
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
                  child: WetPaintCardBack(height: cardHeight),
                )
              : WetPaintCardFront(shimmerPhase: _shimmerController.value, height: cardHeight),
        ),
      ),
    );
  }
}
