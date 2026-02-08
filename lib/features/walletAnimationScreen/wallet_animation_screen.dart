import 'package:bank/app/design/colors/app_colors.dart';
import 'package:bank/app/design/theme/app_theme.dart';
import 'package:bank/core/base/view/base_vew.dart';
import 'package:flutter/material.dart';

import 'binding/wallet_screen_binding.dart';
import 'cubit/wallet_animation_cubit.dart';
import 'models/transaction.dart';
import 'widgets/home_overlay/home_overlay.dart';
import 'widgets/transactions/transaction_item.dart';
import 'widgets/visa_card/visa_card.dart';

part 'widgets/balance/balance.dart';
part 'widgets/slivers/wallet_header_sliver.dart';
part 'widgets/transactions/transaction_card.dart';

class WalletAnimationScreen extends BaseView<WalletAnimationCubit> {
  WalletAnimationScreen({super.key}) : super(dependencies: WalletScreenBinding());

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    final contentTop = topPadding > 44 ? 44.0 : topPadding;
    final overlayHeight = contentTop + AppSpacing.islandStartHeight;

    const double visaCardAreaHeight = 240.0;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // 1. Fixed header: Visa card (not scrollable)
              SizedBox(
                height: overlayHeight + visaCardAreaHeight,
                child: _WalletFlexibleSpace(overlayHeight: overlayHeight),
              ),
              // 2. Balance on top of transactions; only the list scrolls
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: const _TransactionsCard()),
                    Align(
                      alignment: Alignment.topCenter,
                      child: _BalanceCard(
                        balance: '\$24,500.00',
                        isLight: Theme.of(context).brightness == .light,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //@ Send to, profile, add: always visible on top (never scroll away)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: overlayHeight,
            child: HomeOverlay(
              topPadding: contentTop,
              onProfileClick: () => Navigator.of(context).pushNamed('/profile'),
              showProfileButton: true,
            ),
          ),
        ],
      ),
    );
  }
}
