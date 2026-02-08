part of '../visa_card.dart';

class _VisaCardFront extends StatelessWidget {
  const _VisaCardFront({required this.shimmerPhase, required this.height});

  final double shimmerPhase;
  final double height;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.2);

    final brandFontSize = (screenWidth * 0.055).clamp(18.0, 22.0) * textScale;
    final virtualFontSize = (screenWidth * 0.025).clamp(8.0, 10.0) * textScale;
    final dotsFontSize = (screenWidth * 0.06).clamp(20.0, 24.0) * textScale;
    final numberFontSize = (screenWidth * 0.05).clamp(16.0, 20.0) * textScale;
    final visaFontSize = (screenWidth * 0.07).clamp(24.0, 28.0) * textScale;

    return RepaintBoundary(
      child: Container(
        width: .infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: .circular(AppBorderRadius.card),
          gradient: AppGradients.cardBackground,
          boxShadow: AppShadows.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: .circular(AppBorderRadius.card),
          child: Stack(
            children: [
              // BackgroundOverlayPainter was a ~8% black overlay for depth; effect was negligible, removed.
              CustomPaint(
                size: Size.infinite,
                painter: VisaCardPainter(shimmerPhase: shimmerPhase),
              ),
              Padding(
                padding: const .all(AppSpacing.cardPadding),
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: .min,
                            spacing: AppSpacing.sm,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: .circle,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  'NEXUS',
                                  style: AppTextStyles.cardBrand.copyWith(
                                    color: Colors.white,
                                    fontSize: brandFontSize,
                                  ),
                                  overflow: .ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'VIRTUAL',
                            style: AppTextStyles.cardVirtual.copyWith(
                              color: AppColors.silverText,
                              fontSize: virtualFontSize,
                            ),
                            overflow: .ellipsis,
                            maxLines: 1,
                            textAlign: .right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .end,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: .min,
                            crossAxisAlignment: .end,
                            children: [
                              Text(
                                '••',
                                style: AppTextStyles.cardNumber.copyWith(
                                  color: AppColors.electricAccent,
                                  fontWeight: .w900,
                                  letterSpacing: 2,
                                  fontSize: dotsFontSize,
                                ),
                              ),
                              Padding(
                                padding: const .only(left: AppSpacing.sm - 2, bottom: 2),
                                child: Text(
                                  '1234',
                                  style: AppTextStyles.cardNumber.copyWith(
                                    color: AppColors.spaceStart,
                                    fontSize: numberFontSize,
                                  ),
                                  overflow: .ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'VISA',
                            style: AppTextStyles.cardVisa.copyWith(
                              color: AppColors.spaceStart,
                              fontSize: visaFontSize,
                            ),
                            overflow: .ellipsis,
                            maxLines: 1,
                            textAlign: .right,
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
      ),
    );
  }
}
