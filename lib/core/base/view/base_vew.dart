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
///   const LoginScreen({super.key}) : super();
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
  const BaseView({
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
  ///
  /// Note: This getter can only be accessed after the widget is mounted.
  /// Use it in the build method or lifecycle methods, not in the constructor.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final cubit = this.cubit; // Access cubit here
  ///   return ...
  /// }
  /// ```
  C get cubit {
    // Access cubit via state registry
    final state = _StateFinder.findState<C>(this);
    if (state == null) {
      throw StateError(
        'Cannot access cubit before the widget is mounted. '
        'Access it in the build method or after initState.',
      );
    }
    return state.cubit as C;
  }

  @override
  // ignore: library_private_types_in_public_api
  _State<BaseView<BaseCubit<dynamic>>, C> createState() => _State<BaseView, C>();

  /// Builds the widget's UI based on the current [BuildContext].
  /// You must implement this in subclasses to define the widget's content.
  @protected
  Widget build(BuildContext context);
}

/// Helper class to find state instances
class _StateFinder {
  static _State<BaseView, BaseCubit>? findState<C extends BaseCubit>(BaseView<C> widget) {
    return _stateRegistry[widget];
  }

  static final Map<BaseView, _State<BaseView, BaseCubit>> _stateRegistry = {};
}

class _State<T extends BaseView, C extends BaseCubit> extends State<T> {
  late final C cubit; // Ensures cubit persists

  @override
  @protected
  void initState() {
    super.initState();
    _StateFinder._stateRegistry[widget] = this as _State<BaseView, BaseCubit>;
    widget.dependencies?.inject();
    cubit = get<C>(); // Initialize cubit only once
  }

  @override
  void dispose() {
    _StateFinder._stateRegistry.remove(widget);
    getIt.unregister<C>(disposingFunction: (instance) => instance.onDispose());
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
          AppLogger.white('${widget.runtimeType} rebuilt');
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
