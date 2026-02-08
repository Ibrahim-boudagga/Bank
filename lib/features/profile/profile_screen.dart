import 'package:bank/core/base/view/base_vew.dart';
import 'package:flutter/material.dart';

import 'binding/profile_binding.dart';
import 'cubit/profile_cubit.dart';
import 'widgets/profile_screen_content.dart';

/// Profile feature screen. Uses [BaseView] and [ProfileCubit].
class ProfileScreen extends BaseView<ProfileCubit> {
  ProfileScreen({super.key}) : super(dependencies: ProfileBinding());

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return ProfileScreenContent(
      topPadding: topPadding,
      onBack: () => Navigator.of(context).maybePop(),
    );
  }
}
