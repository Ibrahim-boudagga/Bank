part of '../vcisa_card.dart';

class _VcisaCardFront extends StatelessWidget {
  final double shimmerPhase;
  final double height;

  const _VcisaCardFront({required this.shimmerPhase, required this.height});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.2);

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
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 20, spreadRadius: 0)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: BackgroundOverlayPainter()),
            CustomPaint(
              size: Size.infinite,
              painter: VisaCardPainter(shimmerPhase: shimmerPhase),
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
