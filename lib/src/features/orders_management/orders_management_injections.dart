import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/orders_management/data/datasorces/order_requests_datasource.dart';
import 'package:bandasybandas/src/features/orders_management/data/datasorces/order_requests_datasource_impl.dart';
import 'package:bandasybandas/src/features/orders_management/data/repositories/order_requests_repository_impl.dart';
import 'package:bandasybandas/src/features/orders_management/domain/repositories/order_requests_repository.dart';
import 'package:bandasybandas/src/features/orders_management/domain/usecases/order_requests_usecases.dart';
import 'package:bandasybandas/src/features/orders_management/ui/pages/orders_requests_detail/cubit/order_requests_page_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Registra todas las dependencias para el feature de 'Orders Management'.
void initOrdersManagementInjections(FirebaseFirestore firestore) {
  // --- Cubit (Presentation Layer) ---
  // Se registra como 'factory' porque queremos una nueva instancia cada vez
  // que una página la necesite, para evitar problemas de estado entre pantallas.
  sl
    ..registerFactory(
      () => OrderRequestsPageCubit(
        getOrdersRequests: sl(),
        addOrderRequest: sl(),
      ),
    )

    // ----- Use Cases (Domain Layer) ---
    // Orders
    ..registerLazySingleton(() => GetOrderRequests(sl()))
    ..registerLazySingleton(() => AddOrderRequest(sl()))

    // --- Repository (Data Layer) --- interfaz del dominio
    // OrderRequestsRepository
    ..registerLazySingleton<OrderRequestsRepository>(
      () => OrderRequestsRepositoryImpl(sl()),
    )

    // --- Data Source (Data Layer) ---
    ..registerLazySingleton<OrderRequestsDatasource>(
      () => OrderRequestsDatasourceImpl(firestore),
    );
}
