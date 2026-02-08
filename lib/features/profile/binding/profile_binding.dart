import 'package:bank/core/base/dependencies/dependencies.dart';
import 'package:bank/features/profile/cubit/profile_cubit.dart';
import 'package:bank/features/profile/cubit/profile_state.dart';

class ProfileBinding extends Dependencies {
  @override
  void inject() {
    getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(const ProfileState()));
  }
}
