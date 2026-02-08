part of '../visa_card.dart';

class _VisaCardBack extends StatelessWidget {
  const _VisaCardBack({
    required this.height,
    required this.cvc,
    required this.cardHolder,
    // ignore: unused_element_parameter
    this.holderSignature,
  });

  final double height;
  final String cvc;
  final String cardHolder;
  final String? holderSignature;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: .circular(AppBorderRadius.card),
        gradient: AppGradients.cardBackBackground,
        boxShadow: AppShadows.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: .circular(AppBorderRadius.card),
        child: Stack(
          children: [
            Container(decoration: BoxDecoration(gradient: AppGradients.cardBackOverlay)),
            Column(
              spacing: AppSpacing.lg,
              children: [
                const VerticalSpacing(spacing: AppSpacing.md),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: const BoxDecoration(gradient: AppGradients.cardMagStripe),
                ),
                Padding(
                  padding: const .symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: AppSpacing.sm,
                    children: [
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: .circular(AppBorderRadius.xs),
                                border: .all(color: Colors.white, width: 1),
                              ),
                              padding: const .only(left: AppSpacing.md),
                              alignment: .centerLeft,
                              child: Text(
                                holderSignature ?? 'Authorized Signature',
                                style: AppTextStyles.cardBackSignature.copyWith(
                                  color: Colors.black.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ),

                          Text(
                            "CVC",
                            style: AppTextStyles.cardBackCvv.copyWith(
                              color: AppColors.spaceStart.withValues(alpha: 0.6),
                            ),
                          ),
                          Container(
                            width: 64,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: .circular(AppBorderRadius.sm),
                              boxShadow: AppShadows.cardBackCvcShadow,
                            ),
                            alignment: .center,
                            child: Text(
                              cvc,
                              style: AppTextStyles.cardBackCvcValue.copyWith(
                                color: AppColors.electricAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: .centerLeft,
                        child: Text(
                          'CARD HOLDER',
                          style: AppTextStyles.cardBackLabel.copyWith(
                            color: AppColors.spaceStart.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Text(
                        cardHolder,
                        style: AppTextStyles.cardBackValue.copyWith(
                          color: AppColors.spaceStart,
                          fontFamily: 'serif',
                        ),
                        maxLines: 1,
                        overflow: .ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
