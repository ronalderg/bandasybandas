import 'package:bandasybandas/src/app/bloc/settings/settings_event.dart';
import 'package:bandasybandas/src/app/bloc/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Gestiona el estado de la configuración de la UI, como el tema.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ThemeModeChanged>(
      (event, emit) => emit(SettingsState(themeMode: event.themeMode)),
    );
  }
}
