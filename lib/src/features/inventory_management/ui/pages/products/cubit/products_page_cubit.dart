import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/usage_type.dart'; // For CustomerProductStatus
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/add_customer_product.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/inventory_movement_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/products_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/products/cubit/products_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductsPageCubit extends Cubit<ProductsPageState> {
  ProductsPageCubit({
    required this.getProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.addCustomerProduct,
    required this.addInventoryMovement,
  }) : super(ProductsPageInitial());

  final GetProducts getProducts;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final AddCustomerProduct addCustomerProduct;
  final AddInventoryMovement addInventoryMovement;

  StreamSubscription<List<ProductModel>>? _productsSubscription;

  Future<void> loadProducts() async {
    emit(ProductsPageLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(
        ProductsPageError('Error al cargar productos: ${failure.message}'),
      ),
      (stream) {
        _productsSubscription?.cancel();
        _productsSubscription = stream.listen((products) {
          emit(ProductsPageLoaded(products));
        });
      },
    );
  }

  Future<void> createProduct(ProductModel product) async {
    final result = await addProduct(product);
    result.fold(
      (failure) => emit(
        ProductsPageError('Error al crear producto: ${failure.message}'),
      ),
      (_) {
        // El stream se encargará de actualizar la lista, no es necesario emitir aquí.
      },
    );
  }

  Future<void> updateExistingProduct(ProductModel product) async {
    final result = await updateProduct(product);
    result.fold(
      (failure) => emit(
        ProductsPageError('Error al actualizar producto: ${failure.message}'),
      ),
      (_) {
        // El stream se encargará de actualizar la lista, no es necesario emitir aquí.
      },
    );
  }

  Future<void> deleteExistingProduct(String productId) async {
    final result = await deleteProduct(productId);
    result.fold(
      (failure) => emit(
        ProductsPageError('Error al eliminar producto: ${failure.message}'),
      ),
      (_) {
        // El stream se encargará de actualizar la lista, no es necesario emitir aquí.
      },
    );
  }

  /// Transfiere un producto a un cliente, actualizando el inventario del cliente
  /// y registrando el movimiento.
  Future<void> transferProduct({
    required ProductModel updatedProduct,
    required String customerId,
    required String itemId,
  }) async {
    debugPrint('--- INICIO TRANSFER PRODUCT ---');
    debugPrint(
      'Producto: ${updatedProduct.id}, Cliente: $customerId, Item: $itemId',
    );

    // 1. Actualizar el producto (marcar como vendido/trasladado)
    final updateResult = await updateProduct(updatedProduct);

    updateResult.fold(
      (failure) {
        debugPrint('ERROR: Falló al actualizar producto: ${failure.message}');
        emit(
          ProductsPageError(
            'Falló al actualizar el producto: ${failure.message}',
          ),
        );
      },
      (_) async {
        debugPrint(
          'Producto actualizado correctamente. Consultando inventario cliente...',
        );

        // 2. Crear nuevo registro de producto en cliente
        debugPrint('Creando nuevo registro de producto en cliente...');
        final newCustomerProduct = CustomerProductModel(
          id: '', // Firestore generará el ID
          customerId: customerId,
          productId: updatedProduct.id,
          serialNumber: updatedProduct.serial,
          installedAt: DateTime.now(),
          productStatus: CustomerProductStatus.transferred,
          createdAt: Timestamp.now(),
          // Otros campos opcionales
        );

        final addResult = await addCustomerProduct(newCustomerProduct);
        addResult.fold(
          (failure) {
            debugPrint(
              'ERROR: Falló al crear producto en cliente: ${failure.message}',
            );
            emit(
              ProductsPageError(
                'Error al asignar producto al cliente: ${failure.message}',
              ),
            );
          },
          (_) => debugPrint('Producto asignado al cliente exitosamente.'),
        );

        // 4. Registrar el movimiento
        debugPrint('Registrando movimiento de inventario...');
        final movement = InventoryMovementModel(
          id: '', // Firestore generará el ID
          itemId: itemId,
          productId: updatedProduct.id,
          productSerial: updatedProduct.serial,
          customerId: customerId,
          type: InventoryMovementType.transferOut,
          quantity: 1,
          date: DateTime.now(),
          userId: 'system', // TODO(Ronder): Obtener ID del usuario actual
          observations: 'Traslado de producto ${updatedProduct.name}',
        );

        final movementResult = await addInventoryMovement(movement);
        movementResult.fold(
          (failure) {
            debugPrint(
              'ERROR: Falló al registrar movimiento: ${failure.message}',
            );
            emit(
              ProductsPageError(
                'Error al registrar movimiento: ${failure.message}',
              ),
            );
          },
          (_) => debugPrint('Movimiento registrado exitosamente.'),
        );

        debugPrint('--- FIN TRANSFER PRODUCT ---');
      },
    );
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}
