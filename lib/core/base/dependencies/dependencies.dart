import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
T get<T extends Object>() => getIt.get<T>();

abstract class Dependencies {
  void inject();
}
