// lib/src/app/bloc/app_bloc_observer.dart
import 'dart:developer';
import 'package:bloc/bloc.dart';

/// Un [BlocObserver] simple para registrar eventos, cambios y errores.
/// Útil para depuración.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, )');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, , )');
    super.onError(bloc, error, stackTrace);
  }
}
