import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/shared/data/datasources/branches_datasource.dart';
import 'package:bandasybandas/src/shared/data/datasources/branches_datasource_impl.dart';
import 'package:bandasybandas/src/shared/data/repositories/branches_repository_impl.dart';
import 'package:bandasybandas/src/shared/domain/repositories/branches_repository.dart';
import 'package:bandasybandas/src/shared/domain/usecases/branches_usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Registra todas las dependencias para datos compartidos en toda la aplicación.
void initSharedManagementInjections(FirebaseFirestore firestore) {
  sl
    // ----- Use Cases (Domain Layer) ---
    ..registerLazySingleton(() => GetBranches(sl()))
    ..registerLazySingleton(() => AddBranch(sl()))
    ..registerLazySingleton(() => UpdateBranch(sl()))
    ..registerLazySingleton(() => DeleteBranch(sl()))

    // --- Repository (Data Layer) --- interfaz del dominio
    ..registerLazySingleton<BranchesRepository>(
      () => BranchesRepositoryImpl(sl<BranchesDatasource>()),
    )

    // --- Data Source (Data Layer) ---
    ..registerLazySingleton<BranchesDatasource>(
      () => BranchesDatasourceImpl(firestore),
    );
}
