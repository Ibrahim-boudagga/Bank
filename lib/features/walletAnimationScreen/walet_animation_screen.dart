import 'package:bank/core/base/view/base_vew.dart';
import 'package:flutter/material.dart';

import 'binding/wallet_screen_binding.dart';
import 'cubit/wallet_animation_cubit.dart';
import 'widgets/visa_card/vcisa_card.dart';

class WalletAnimationScreen extends BaseView<WalletAnimationCubit> {
  WalletAnimationScreen({super.key}) : super(dependencies: WalletScreenBinding());

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const .symmetric(horizontal: 20),
        child: Column(children: [VcisaCard()]),
      ),
    ),
  );
}
