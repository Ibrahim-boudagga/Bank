import 'package:flutter/material.dart';

/// Controller for Visa card flip animation, shimmer, and drag gestures.
///
/// Call [init] with a [TickerProvider] (e.g. your State) and [dispose] when done.
/// No setState — use [listenable] or the [ValueNotifier]s with any state management.
class VisaCardController {
  VisaCardController();

  late AnimationController _rotationController;
  late AnimationController _shimmerController;
  bool _initialized = false;

  /// Current Y rotation in degrees.
  final rotation = ValueNotifier<double>(0.0);

  /// True when the front face is visible.
  final isFrontVisible = ValueNotifier<bool>(true);

  /// Shimmer phase 0.0–1.0 for the front card paint.
  final shimmerPhase = ValueNotifier<double>(0.0);

  double _dragStartFace = 0.0;
  Animation<double>? _rotationAnimation;

  ///- Single [Listenable] for rotation + visibility + shimmer (one [AnimatedBuilder]).
  Listenable get listenable => .merge([rotation, isFrontVisible, shimmerPhase]);

  /// Creates and starts the rotation and shimmer controllers. Call from your State.initState.
  void init(TickerProvider vsync) {
    if (_initialized) return;
    _initialized = true;

    _rotationController = .new(vsync: vsync, duration: const .new(milliseconds: 600));
    _shimmerController = .new(vsync: vsync, duration: const .new(milliseconds: 3500))..repeat();

    _shimmerController.addListener(() => shimmerPhase.value = _shimmerController.value);
  }

  /// Handle drag start - record the starting face
  void onDragStart() {
    _dragStartFace = (rotation.value / 180).roundToDouble() * 180;
  }

  /// Handle drag update - rotate card with magnetic effect
  void onDragUpdate(DragUpdateDetails details) {
    final direction = _isBackVisible(rotation.value) ? -1.0 : 1.0;
    final current = rotation.value;

    final angleInHalfTurn = ((current - _dragStartFace) % 180 + 180) % 180;
    final distanceFromMid = (angleInHalfTurn - 90).abs();
    final magneticFactor = _lerp(0.25, 1.0, (distanceFromMid / 90).clamp(0.0, 1.0));

    final proposed = current + details.primaryDelta! * 0.6 * magneticFactor * direction;

    rotation.value = proposed.clamp(_dragStartFace - 180, _dragStartFace + 180);

    _updateVisibility();
  }

  /// Handle drag end - animate to nearest face
  void onDragEnd(DragEndDetails details) {
    final current = rotation.value;
    final base = _dragStartFace;
    final offset = current - base;
    final velocity = details.velocity.pixelsPerSecond.dx;

    final target = _getTarget(velocity, base, offset);

    _animateToTarget(current, target);
  }

  double _getTarget(double velocity, double base, double offset) => (velocity > 800 || offset > 60)
      ? base + 180
      : (velocity < -800 || offset < -60)
      ? base - 180
      : base;

  /// Programmatically flip the card
  void flip() {
    final current = rotation.value;
    final base = (current / 180).roundToDouble() * 180;
    final target = base + 180;

    _animateToTarget(current, target);
  }

  /// Flip to front face
  void flipToFront() {
    final current = rotation.value;
    final normalizedAngle = (current % 360 + 360) % 360;

    if (normalizedAngle >= 90 && normalizedAngle <= 270) {
      flip();
    }
  }

  /// Flip to back face
  void flipToBack() {
    final current = rotation.value;
    final normalizedAngle = (current % 360 + 360) % 360;

    if (normalizedAngle < 90 || normalizedAngle > 270) {
      flip();
    }
  }

  /// Reset card to front face
  void reset() {
    rotation.value = 0.0;
    isFrontVisible.value = true;
  }

  void _animateToTarget(double start, double end) {
    if (!_initialized) return;

    _rotationController.reset();
    _rotationAnimation = Tween<double>(
      begin: start,
      end: end,
    ).animate(CurvedAnimation(parent: _rotationController, curve: Curves.easeOut));

    void listener() {
      rotation.value = _rotationAnimation!.value;
      _updateVisibility();
    }

    void statusListener(AnimationStatus status) {
      if (status == .completed) {
        _rotationAnimation!.removeListener(listener);
        _rotationController.removeStatusListener(statusListener);
      }
    }

    _rotationAnimation!.addListener(listener);
    _rotationController.addStatusListener(statusListener);
    _rotationController.forward();
  }

  void _updateVisibility() {
    isFrontVisible.value = !_isBackVisible(rotation.value);
  }

  bool _isBackVisible(double angle) {
    final normalizedAngle = (angle % 360 + 360) % 360;
    return normalizedAngle >= 90 && normalizedAngle <= 270;
  }

  double _lerp(double start, double end, double t) => start + (end - start) * t;

  /// Disposes all controllers and notifiers. Call from your State.dispose.
  void dispose() {
    if (!_initialized) return;
    _initialized = false;

    _rotationController.dispose();
    _shimmerController.dispose();
    rotation.dispose();
    isFrontVisible.dispose();
    shimmerPhase.dispose();
  }
}
