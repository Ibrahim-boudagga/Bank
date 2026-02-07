import 'package:bank/core/base/dependencies/dependencies.dart';

import '../cubit/wallet_animation_cubit.dart';
import '../cubit/wallet_animation_state.dart';

class WalletScreenBinding extends Dependencies {
  @override
  void inject() {
    getIt.registerLazySingleton<WalletAnimationCubit>(
      () => WalletAnimationCubit(WalletAnimationState()),
    );
  }
}
