// lib/src/injection_container.dart

// ignore_for_file: cascade_invocations

import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- External ---
  // Registra la instancia de FirebaseAuth para que pueda ser inyectada.
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // --- Features: Authentication ---

  // Repositories
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(firebaseAuth: sl()),
  );
}
