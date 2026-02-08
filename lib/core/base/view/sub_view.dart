import 'package:bank/core/base/cubit/base_cubit.dart';
import 'package:bank/core/base/dependencies/dependencies.dart';
import 'package:flutter/material.dart';

abstract class SubView<C extends BaseCubit> extends StatelessWidget {
  /// and current state of the [Cubit].
  const SubView({super.key});

  /// The [Cubit] instance.
  C get cubit => get<C>();

  /// Builds the widget's UI based on the current [BuildContext].
  /// You must implement this in subclasses to define the widget's content.
  @override
  @protected
  Widget build(BuildContext context);
}
