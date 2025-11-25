import 'dart:async';

import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/get_customer_products.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_machines/customer_machines_state.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/products_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

/// Cubit para gestionar el estado de las máquinas del cliente.
class CustomerMachinesCubit extends Cubit<CustomerMachinesState> {
  CustomerMachinesCubit({
    required this.getCustomerProducts,
    required this.getProducts,
  }) : super(CustomerMachinesInitial());

  final GetCustomerProducts getCustomerProducts;
  final GetProducts getProducts;

  StreamSubscription<List<ProductModel>>? _productsSubscription;
  StreamSubscription<Either<Failure, List<CustomerProductModel>>>?
      _customerProductsSubscription;

  /// Carga las máquinas asociadas a un cliente.
  Future<void> loadCustomerMachines(String customerId) async {
    emit(CustomerMachinesLoading());

    // Primero obtenemos todos los productos disponibles
    final productsResult = await getProducts(NoParams());

    productsResult.fold(
      (failure) => emit(
        CustomerMachinesError(
          'Error al cargar productos: ${failure.message}',
        ),
      ),
      (productsStream) {
        // Escuchamos el stream de productos
        _productsSubscription?.cancel();
        final productsMap = <String, ProductModel>{};

        _productsSubscription = productsStream.listen((products) {
          // Actualizamos el mapa de productos
          productsMap.clear();
          for (final product in products) {
            productsMap[product.id] = product;
          }

          // Ahora obtenemos los customer_products
          final customerProductsStream = getCustomerProducts(customerId);

          _customerProductsSubscription?.cancel();
          _customerProductsSubscription = customerProductsStream.listen(
            (either) {
              either.fold(
                (failure) => emit(
                  CustomerMachinesError(
                    'Error al cargar máquinas: ${failure.message}',
                  ),
                ),
                (customerProducts) {
                  emit(
                    CustomerMachinesLoaded(
                      customerProducts: customerProducts,
                      products: Map.from(productsMap),
                    ),
                  );
                },
              );
            },
          );
        });
      },
    );
  }

  @override
  Future<void> close() {
    _customerProductsSubscription?.cancel();
    _productsSubscription?.cancel();
    return super.close();
  }
}
