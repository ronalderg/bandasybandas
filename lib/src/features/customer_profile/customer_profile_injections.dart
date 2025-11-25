import 'package:bandasybandas/src/app/injection_container.dart';
import 'package:bandasybandas/src/features/customer_profile/data/datasources/customer_profile_datasource.dart';
import 'package:bandasybandas/src/features/customer_profile/data/datasources/customer_profile_datasource_impl.dart';
import 'package:bandasybandas/src/features/customer_profile/data/repositories/customer_profile_repository_impl.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/repositories/customer_profile_repository.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/add_customer_product.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/get_customer_products.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/update_customer_product.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_inventory/customer_inventory_cubit.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_machines/customer_machines_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Registra todas las dependencias para el feature de 'Customer Profile'.
void initCustomerProfileInjections(FirebaseFirestore firestore) {
  // --- Cubit (Presentation Layer) ---
  // Se registra como 'factory' porque queremos una nueva instancia cada vez
  // que una página la necesite, para evitar problemas de estado entre pantallas.
  sl
    ..registerFactory(
      () => CustomerMachinesCubit(
        getCustomerProducts: sl(),
        getProducts: sl(),
      ),
    )
    ..registerFactory(
      () => CustomerInventoryCubit(
        getCustomerProducts: sl(),
        getProducts: sl(),
      ),
    )

    // ----------------------- Use Cases (Domain Layer) -----------------------
    ..registerLazySingleton(() => GetCustomerProducts(sl()))
    ..registerLazySingleton(() => AddCustomerProduct(sl()))
    ..registerLazySingleton(() => UpdateCustomerProduct(sl()))

    // ----------- Repository (Data Layer) --- interfaz del dominio ------------
    ..registerLazySingleton<CustomerProfileRepository>(
      () => CustomerProfileRepositoryImpl(sl<CustomerProfileDatasource>()),
    )
 
    // ------------------------ Data Source (Data Layer) -----------------------
    ..registerLazySingleton<CustomerProfileDatasource>(
      () => CustomerProfileDatasourceImpl(firestore),
    );
}
