import 'package:bank/core/utils/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class BaseCubit<S> extends Cubit<S> with WidgetsBindingObserver {
  bool debuggingEnabled = true;

  bool _isPaused = false;

  BaseCubit(super.initialState) {
    onInit();
  }

  @mustCallSuper
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
    if (debuggingEnabled) {
      AppLogger.yellow('$runtimeType initialized');
    }
    _observeLifecycle();
  }

  @mustCallSuper
  @protected
  void onReady() {
    if (debuggingEnabled) {
      AppLogger.green('$runtimeType ready');
    }
  }

  @mustCallSuper
  void onDispose() async {
    _removeLifecycleObserver();
    await close();
    if (debuggingEnabled) {
      AppLogger.red('$runtimeType closed');
    }
  }

  @protected
  @mustCallSuper
  void onPause() {
    if (_isPaused) return;
    _isPaused = true;
    if (debuggingEnabled) {
      AppLogger.cyan('$runtimeType paused at $time');
    }
  }

  @protected
  @mustCallSuper
  void onResume() {
    if (!_isPaused) return;
    _isPaused = false;
    if (debuggingEnabled) {
      AppLogger.white('$runtimeType resumed at $time');
    }
  }

  @protected
  void _observeLifecycle() => WidgetsBinding.instance.addObserver(this);

  @protected
  void _removeLifecycleObserver() => WidgetsBinding.instance.removeObserver(this);

  @override
  @protected
  void didChangeAppLifecycleState(AppLifecycleState state) => switch (state) {
    AppLifecycleState.resumed => onResume(),
    AppLifecycleState.paused || AppLifecycleState.inactive => onPause(),
    _ => null,
  };

  String get time => DateTime.now().toLocal().toString().split(' ')[1].substring(0, 8);
}
