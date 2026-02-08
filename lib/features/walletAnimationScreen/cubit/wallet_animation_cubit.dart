import 'package:bank/core/base/exports/export.dart';
import 'package:bank/features/walletAnimationScreen/cubit/wallet_animation_state.dart';

import '../widgets/home_overlay/cbit_mixin/home_overlay_cubit.dart';
import '../widgets/transactions/cubit_mixin/transactions_cubit_mixin.dart';

class WalletAnimationCubit extends BaseCubit<WalletAnimationState>
    with TransactionsCubitMixin, HomeOverlayCubitMixin {
  WalletAnimationCubit(super.initialState);

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchTransactions();
  }

  void openProfile() {}
}
