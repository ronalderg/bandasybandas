import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/users/data/datasources/users_datasource.dart';
import 'package:bandasybandas/src/features/users/data/datasources/users_datasource_impl.dart';
import 'package:bandasybandas/src/features/users/data/repositories/users_repository_impl.dart';
import 'package:bandasybandas/src/features/users/domain/repositories/users_repository.dart';
import 'package:bandasybandas/src/features/users/domain/usecases/users_usecases.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Registra todas las dependencias para el feature de 'Users'.
///
/// Esta función debe ser llamada en el `injection_container.dart` principal
/// para asegurar que todas las dependencias estén disponibles en la app.
void initUserManagementInjections(FirebaseFirestore firestore) {
  // --- Cubit (Presentation Layer) ---
  // Se registra como 'factory' porque queremos una nueva instancia cada vez
  // que una página la necesite, para evitar problemas de estado entre pantallas.
  sl
    ..registerFactory(
      () => UsersPageCubit(
        getUsers: sl(),
        addUserUseCase: sl(),
      ),
    )

    // --- Use Cases (Domain Layer) ---
    // Se registran como 'lazySingleton' para que se cree una única instancia
    // la primera vez que se soliciten.

    ..registerLazySingleton(() => GetUsers(sl()))
    ..registerLazySingleton(() => AddUser(sl()))

    // --- Repository (Domain/Data Layer) ---
    // Se registra la implementación (`UserRepositoryImpl`) para la abstracción
    // (`UserRepository`) definida en el dominio.
    ..registerLazySingleton<UsersRepository>(
      () => UsersRepositoryImpl(
        sl<UsersDatasource>(),
      ),
    )

    // --- Data Source (Data Layer) ---
    // Se registra la implementación que se comunica directamente con Firestore.
    ..registerLazySingleton<UsersDatasource>(
      () => UsersDatasourceImpl(
        firestore,
      ),
    );
}
