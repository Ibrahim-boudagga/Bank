import 'package:bank/core/utils/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/base_cubit.dart';
import '../dependencies/dependencies.dart';

/// A base widget for providing a Cubit to its child widget tree. It allows you to inject
/// dependencies and manage the lifecycle of the provided Cubit.
///
/// Example:
/// ```dart
/// class LoginScreen extends BaseView<LoginCubit> {
///   LoginScreen({super.key}) : super(dependencies: LoginDependencies());
///
///   @override
///   Widget build(BuildContext context) {
///     return CubitBuilder<LoginCubit, LoginState>(
///       builder: (context, state) {
///         return switch (state) {
///           LoginInitialState() => const IdleWidget(),
///           LoginLoadingState() => const LoadingWidget(),
///           LoginFailureState(error: final String error) => ErrorWidget(error: error),
///           LoginSuccessState() => SuccessWidget(),
///         };
///       },
///     );
///   }
/// }
/// ```

abstract class BaseView<C extends BaseCubit> extends StatefulWidget {
  /// Creates a [BaseView].
  ///
  /// - [dependencies]: Optional. A [Dependencies] instance for lazy or eager dependency injection.
  /// - [lazy]: Whether to create the [Cubit] lazily or eagerly. Defaults to `true` (lazy).
  /// - [listenWhen]: Optional. A function that decides when to listen based on the previous
  /// and current state of the [Cubit].
  /// - [onUpdate]: Optional callback when state updates
  /// - [fullRebuildWhen]: Optional. A function that decides when to rebuild the entire widget
  BaseView({
    super.key,
    this.dependencies,
    this.lazy = true,
    this.listenWhen,
    this.onUpdate,
    this.fullRebuildWhen,
    this.debugStateChanges = false,
  });

  final Dependencies? dependencies;

  /// Whether to create the [Cubit] lazily or eagerly. Defaults to `true`.
  final bool lazy;

  /// A function that determines when to listen based on the previous and current state.
  /// If `null`, will listen on every state change.
  final BlocListenerCondition<dynamic>? listenWhen;

  final void Function(BuildContext, dynamic)? onUpdate;
  final bool Function(BuildContext, dynamic)? fullRebuildWhen;

  /// Whether to print state changes to the console. Defaults to `false`.
  final bool debugStateChanges;

  /// The [Cubit] provided to the widget.
  C get cubit => _state!.cubit;

  _State<BaseView, C>? _state;

  @override
  // ignore: library_private_types_in_public_api
  _State<BaseView<BaseCubit<dynamic>>, C> createState() => _State<BaseView, C>();

  /// Builds the widget's UI based on the current [BuildContext].
  /// You must implement this in subclasses to define the widget's content.
  @protected
  Widget build(BuildContext context);
}

class _State<T extends BaseView, C extends BaseCubit> extends State<T> {
  late final C cubit; // Ensures cubit persists

  @override
  @protected
  void initState() {
    super.initState();
    widget._state = this;
    widget.dependencies?.inject();
    cubit = get<C>(); // Initialize cubit only once
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._state = this;
  }

  @override
  void dispose() {
    getIt.unregister<C>(disposingFunction: (instance) => instance.onDispose());
    widget._state = null;
    super.dispose();
  }

  @override
  @protected
  Widget build(BuildContext context) => BlocProvider<C>(
    create: (_) => cubit,
    lazy: widget.lazy,
    child: BlocListener<C, dynamic>(
      listenWhen: widget.listenWhen,
      listener: (context, state) {
        if (widget.fullRebuildWhen?.call(context, state) == true) {
          setState(() {
            AppLogger.white('${widget.runtimeType} rebuilt');
          });
        }
        if (widget.onUpdate != null) widget.onUpdate!.call(context, state);

        if (widget.debugStateChanges) {
          AppLogger.cyan('${widget.runtimeType} state: ${state.toString().split('(').first}');
        }
      },
      child: widget.build(context),
    ),
  );
}
