// lib/src/injection_container.dart

// ignore_for_file: cascade_invocations
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository_impl.dart';
import 'package:bandasybandas/src/features/customers/customers_management_injections.dart';
import 'package:bandasybandas/src/features/inventory_management/inventory_management_injections.dart';
import 'package:bandasybandas/src/features/users/users_management_injections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- External ---
  final firestore = FirebaseFirestore.instance;
  // Registra la instancia de FirebaseAuth para que pueda ser inyectada.
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton(() => firestore);

  _initAuthentication();
  initInventoryManagementInjections(firestore);
  initCustomersManagementInjections(firestore);
  initUserManagementInjections(firestore);
}

void _initAuthentication() {
  // Repositories
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(firebaseAuth: sl()),
  );
}
