import 'package:bank/core/base/exports/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'binding/wallet_screen_binding.dart';
import 'cubit/wallet_animation_cubit.dart';
import 'cubit/wallet_animation_state.dart';
import 'widgets/home_overlay/home_overlay.dart';
import 'widgets/transactions/transaction_item.dart';
import 'widgets/visa_card/visa_card.dart';

part 'widgets/balance/balance.dart';
part 'widgets/transactions/empty_transactions.dart';
part 'widgets/transactions/transaction_card.dart';
part 'widgets/visa_card/wallet_header_sliver.dart';

class WalletAnimationScreen extends BaseView<WalletAnimationCubit> {
  WalletAnimationScreen({super.key}) : super(dependencies: WalletScreenBinding());

  @override
  Widget build(BuildContext context) =>
      BlocSelector<WalletAnimationCubit, WalletAnimationState, (TransactionStatus, double)>(
        selector: (state) => (state.status!, state.islandState.height),
        builder: (context, data) {
          final loading = data.$1 == .loading;
          final islandHeight = data.$2;
          final topPadding = MediaQuery.paddingOf(context).top;
          final overlayHeight = islandHeight > AppSpacing.visaCardAreaHeight
              ? (islandHeight + topPadding + AppSpacing.lg)
              : (topPadding + AppSpacing.islandStartHeight + AppSpacing.lg);
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: AppSpacing.visaCardAreaPadding,
                      child: Skeletonizer(
                        enabled: loading,
                        enableSwitchAnimation: true,
                        child: const _WalletCard(),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(child: const _TransactionsCard()),
                          Align(
                            alignment: .topCenter,
                            child: Skeletonizer(
                              enabled: loading,
                              enableSwitchAnimation: true,
                              child: _BalanceCard(balance: 2100.00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: overlayHeight,
                  child: HomeOverlay(
                    topPadding: topPadding,
                    profileImageUrl: '', // Pass user profile image URL when available
                    showProfileButton: true,
                    isLoading: loading,
                  ),
                ),
              ],
            ),
          );
        },
      );
}
