import 'package:bandasybandas/firebase_options.dart';
import 'package:bandasybandas/src/app/app.dart';
import 'package:bandasybandas/src/app/bloc/app_bloc_observer.dart';
import 'package:bandasybandas/src/app/injection_container.dart' as di;
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén inicializados.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa el contenedor de inyección de dependencias.
  await di.init();

  // Configura un observador de BLoC para depuración.
  Bloc.observer = const AppBlocObserver();

  // Ejecuta la aplicación.
  runApp(const App());
}
