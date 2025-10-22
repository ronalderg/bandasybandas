import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/customers/data/datasources/customers_datasource.dart';
import 'package:bandasybandas/src/features/customers/data/datasources/customers_datasource_impl.dart';
import 'package:bandasybandas/src/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:bandasybandas/src/features/customers/domain/repositories/customers_repository.dart';
import 'package:bandasybandas/src/features/customers/domain/usecases/customers_usecases.dart';
import 'package:bandasybandas/src/features/customers/ui/pages/customer_management/cubit/customer_management_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void initCustomersManagementInjections(FirebaseFirestore firestore) {
  // --- Cubit (Presentation Layer) ---
  // Se registra como 'factory' porque queremos una nueva instancia cada vez
  // que una página la necesite, para evitar problemas de estado entre pantallas.
  sl
    ..registerFactory(
      () => CustomersManagementCubit(
        getCustomers: sl(),
        addCustomerUseCase: sl(),
      ),
    )

    // ----- Use Cases (Domain Layer) ---
    // Customers
    ..registerLazySingleton(() => GetCustomers(sl()))
    ..registerLazySingleton(() => AddCustomer(sl()))

    // --- Repository (Data Layer) --- interfaz del dominio
    // CustomersRepository
    ..registerLazySingleton<CustomersRepository>(
      () => CustomersRepositoryImpl(sl<CustomersDatasource>()),
    )

    // --- Data Source (Data Layer) ---
    ..registerLazySingleton<CustomersDatasource>(
      () => CustomersDatasourceImpl(firestore),
    );
}
