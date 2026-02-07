import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'controller/visa_card_controller.dart';
import 'tools/background_overlay_painter.dart';
import 'tools/visa_card_painter.dart';

part 'widgets/back_card.dart';
part 'widgets/front_card.dart';

/// Visa-style card with flip animation and wet-paint shimmer.
///
/// Uses [VisaCardController]: pass [controller] to reuse one (call [VisaCardController.init]
/// and [VisaCardController.dispose] yourself), or the card creates and owns one.
class VcisaCard extends StatefulWidget {
  const VcisaCard({super.key, this.controller});

  final VisaCardController? controller;

  @override
  State<VcisaCard> createState() => _VcisaCardState();
}

class _VcisaCardState extends State<VcisaCard> with TickerProviderStateMixin {
  late final VisaCardController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? VisaCardController();
    if (widget.controller == null) _ownsController = true;

    _controller.init(this);
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = (MediaQuery.sizeOf(context).width * 0.55).clamp(200.0, 240.0);

    return GestureDetector(
      onHorizontalDragStart: (_) => _controller.onDragStart(),
      onHorizontalDragUpdate: _controller.onDragUpdate,
      onHorizontalDragEnd: _controller.onDragEnd,
      child: SizedBox(
        height: cardHeight,
        child: AnimatedBuilder(
          animation: _controller.listenable,
          builder: (context, _) => Transform(
            alignment: .center,
            transform: .identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_controller.rotation.value * 3.14159 / 180),
            child: _controller.isFrontVisible.value
                ? _VcisaCardFront(shimmerPhase: _controller.shimmerPhase.value, height: cardHeight)
                : Transform(
                    alignment: .center,
                    transform: .identity()..rotateY(3.14159),
                    child: _VcisaCardBack(
                      height: cardHeight,
                      cvc: '892',
                      cardHolder: 'IRAHIM BOUDAGGA',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
