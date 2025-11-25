import 'dart:async';

import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/get_customer_products.dart';
import 'package:bandasybandas/src/features/customer_profile/ui/bloc/customer_inventory/customer_inventory_state.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/products_usecases.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

/// Cubit para gestionar el estado del inventario del cliente.
class CustomerInventoryCubit extends Cubit<CustomerInventoryState> {
  CustomerInventoryCubit({
    required this.getCustomerProducts,
    required this.getProducts,
  }) : super(CustomerInventoryInitial());

  final GetCustomerProducts getCustomerProducts;
  final GetProducts getProducts;

  StreamSubscription<List<ProductModel>>? _productsSubscription;
  StreamSubscription<Either<Failure, List<CustomerProductModel>>>?
      _customerProductsSubscription;

  /// Carga el inventario asociado a un cliente.
  Future<void> loadCustomerInventory(String customerId) async {
    debugPrint('--- LOADING CUSTOMER INVENTORY ---');
    debugPrint('Customer ID: $customerId');
    emit(CustomerInventoryLoading());

    // Primero obtenemos todos los productos disponibles
    final productsResult = await getProducts(NoParams());

    productsResult.fold(
      (failure) {
        debugPrint('ERROR: Failed to load products: ${failure.message}');
        emit(
          CustomerInventoryError(
            'Error al cargar productos: ${failure.message}',
          ),
        );
      },
      (productsStream) {
        // Escuchamos el stream de productos
        _productsSubscription?.cancel();
        final productsMap = <String, ProductModel>{};

        _productsSubscription = productsStream.listen((products) {
          debugPrint('Products loaded: ${products.length}');
          // Actualizamos el mapa de productos
          productsMap.clear();
          for (final product in products) {
            productsMap[product.id] = product;
          }

          // Ahora obtenemos el customer_products
          final customerProductsStream = getCustomerProducts(customerId);

          _customerProductsSubscription?.cancel();
          _customerProductsSubscription = customerProductsStream.listen(
            (either) {
              either.fold(
                (failure) {
                  debugPrint(
                    'ERROR: Failed to load customer products: ${failure.message}',
                  );
                  emit(
                    CustomerInventoryError(
                      'Error al cargar inventario: ${failure.message}',
                    ),
                  );
                },
                (customerProducts) {
                  debugPrint(
                    'Customer products loaded: ${customerProducts.length} items',
                  );
                  for (final prod in customerProducts) {
                    debugPrint('  - Product ${prod.productId}: ${prod.status}');
                  }
                  emit(
                    CustomerInventoryLoaded(
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
