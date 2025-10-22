import 'dart:async';

import 'package:bandasybandas/firebase_options.dart';
import 'package:bandasybandas/src/app/app.dart';
import 'package:bandasybandas/src/app/app_config.dart';
import 'package:bandasybandas/src/app/bloc/app_bloc_observer.dart';
import 'package:bandasybandas/src/app/injection_container.dart' as di;
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // runZonedGuarded captura errores que ocurren fuera del framework de Flutter.
  await runZonedGuarded<Future<void>>(() async {
    // Asegura que los bindings de Flutter estén inicializados.
    WidgetsFlutterBinding.ensureInitialized();

    // --- INICIO DE CONFIGURACIÓN DE FLAVOR ---

    // 1. Lee la variable de entorno 'FLAVOR' definida en la compilación.
    // Si no se proporciona, se usa 'development' por defecto.
    const flavorString =
        String.fromEnvironment('FLAVOR', defaultValue: 'development');

    // 2. Convierte el string del flavor al enum AppFlavor correspondiente.
    AppFlavor flavor;
    switch (flavorString.toLowerCase()) {
      case 'production':
        flavor = AppFlavor.production;
      case 'staging':
        flavor = AppFlavor.staging;
      case 'development':
      default:
        flavor = AppFlavor.development;
    }

    // 3. Inicializa la clase de configuración estática con el flavor detectado.
    // ¡Este es el paso clave! Ahora AppConfig.baseUrl, etc., funcionarán.
    AppConfig.appFlavor = flavor;

    // --- FIN DE CONFIGURACIÓN DE FLAVOR ---

    // Inicializa Firebase.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Inicializa el contenedor de inyección de dependencias.
    await di.init();

    // Configura un observador de BLoC para depuración.
    Bloc.observer = const AppBlocObserver();

    // Ejecuta la aplicación.
    runApp(const App());
  }, (error, stack) {
    // Aquí puedes registrar errores no capturados en servicios como
    // Sentry, Firebase Crashlytics, etc.
    debugPrint('Error no capturado en el main: $error');
    debugPrint(stack.toString());
  });
}
