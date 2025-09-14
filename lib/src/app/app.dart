import 'package:bandasybandas/src/app/app_router.dart';
import 'package:bandasybandas/src/app/app_theme.dart';
import 'package:bandasybandas/src/app/bloc/auth/auth_bloc.dart';
import 'package:bandasybandas/src/app/bloc/settings/settings_bloc.dart';
import 'package:bandasybandas/src/app/bloc/settings/settings_state.dart';
import 'package:bandasybandas/src/app/localization/app_localizations.dart';
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

/// [App] es el widget raíz de la aplicación.
///
/// Configura el `BlocProvider` para el estado global de la UI (como el tema y el idioma)
/// y establece el `MaterialApp` con el enrutador, temas y configuración de localización.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(
      authenticationRepository: GetIt.I<AuthenticationRepository>(),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _authBloc,
        ),
        BlocProvider(create: (_) => SettingsBloc()),
      ],
      child: const AppView(),
    );
  }
}

/// [AppView] escucha los cambios en `SettingsBloc` y reconstruye
/// `MaterialApp` cuando el tema o el idioma cambian.
class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    // `BlocBuilder` se reconstruye cuando el estado de `SettingsBloc` cambia.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: _router,

          // --- Tema ---
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode, // Controlado por el BLoC

          // --- Localización ---
          // El locale también es controlado por el estado del BLoC.
          locale: state.locale,
          // Delegados necesarios para que Flutter sepa cómo cargar las traducciones.
          localizationsDelegates: const [
            AppLocalizations.delegate, // Delegado de la aplicación
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Lista de idiomas soportados por la aplicación.
          supportedLocales: AppLocalizations.supportedLocales,

          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
