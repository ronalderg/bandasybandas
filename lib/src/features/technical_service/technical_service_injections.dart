import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/technical_service/data/datasources/technical_service_datasource.dart';
import 'package:bandasybandas/src/features/technical_service/data/datasources/technical_service_datasource_impl.dart';
import 'package:bandasybandas/src/features/technical_service/data/repositories/technical_service_repository_impl.dart';
import 'package:bandasybandas/src/features/technical_service/domain/repositories/technical_service_repository.dart';
import 'package:bandasybandas/src/features/technical_service/domain/usecases/technical_service_usecases.dart';
import 'package:bandasybandas/src/features/technical_service/ui/pages/technical_services/cubit/technical_services_page_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Registra todas las dependencias para el feature de 'Technical Service'.
void initTechnicalServiceInjections(FirebaseFirestore firestore) {
  // --- Cubit (Presentation Layer) ---
  // Se registra como 'factory' porque queremos una nueva instancia cada vez
  // que una página la necesite, para evitar problemas de estado entre pantallas.
  sl
    ..registerFactory(
      () => TechnicalServicesPageCubit(
        getTechnicalServices: sl(),
        addTechnicalServiceUseCase: sl(),
        updateTechnicalServiceUseCase: sl(),
      ),
    )

    // ----------------------- Use Cases (Domain Layer) -----------------------
    ..registerLazySingleton(() => GetTechnicalServices(sl()))
    ..registerLazySingleton(() => AddTechnicalService(sl()))
    ..registerLazySingleton(() => UpdateTechnicalService(sl()))

    // ----------- Repository (Data Layer) --- interfaz del dominio ------------
    ..registerLazySingleton<TechnicalServiceRepository>(
      () => TechnicalServiceRepositoryImpl(sl<TechnicalServiceDatasource>()),
    )

    // ------------------------ Data Source (Data Layer) -----------------------
    ..registerLazySingleton<TechnicalServiceDatasource>(
      () => TechnicalServiceDatasourceImpl(firestore),
    );
}
