import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/models/usage_type.dart'; // For CustomerProductStatus
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/add_customer_product.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/get_customer_products.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/usecases/update_customer_product.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/inventory_movement_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/items_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ItemsCubit extends Cubit<ItemsPageState> {
  ItemsCubit({
    required this.getItems,
    required this.addItemUseCase,
    required this.updateItemUseCase,
    required this.addInventoryMovement,
    required this.addCustomerProduct,
    required this.updateCustomerProduct,
    required this.getCustomerProducts,
  }) : super(ItemsPageInitial());

  final GetItems getItems;
  final AddItem addItemUseCase;
  final UpdateItem updateItemUseCase;
  final AddInventoryMovement addInventoryMovement;
  final AddCustomerProduct addCustomerProduct;
  final UpdateCustomerProduct updateCustomerProduct;
  final GetCustomerProducts getCustomerProducts;
  StreamSubscription<List<ItemModel>>? _itemsSubscription;

  Future<void> loadItems() async {
    emit(ItemsPageLoading());

    final result = await getItems(NoParams());

    result.fold(
      (failure) => emit(
        ItemsPageError(
          'Falló la carga inicial de ítems: ${failure.message}',
        ),
      ),
      (itemsStream) {
        _itemsSubscription?.cancel();
        _itemsSubscription = itemsStream.listen((items) {
          emit(ItemsPageLoaded(items));
        });
      },
    );
  }

  Future<void> addItem(ItemModel item) async {
    // No se emite un estado de carga aquí para no bloquear toda la UI.
    // La actualización de la lista se manejará por el stream.
    final result = await addItemUseCase(item);

    result.fold(
      (failure) => emit(
        ItemsPageError('Falló al agregar el ítem: ${failure.message}'),
      ),
      (_) {}, // En caso de éxito, no hacemos nada, el stream actualizará la UI.
    );
  }

  Future<void> updateItem(ItemModel item) async {
    // No emitimos un estado de carga para una mejor experiencia de usuario.
    // La UI se actualizará automáticamente a través del stream de la lista.
    final result = await updateItemUseCase(item);

    result.fold(
      (failure) => emit(
        ItemsPageError('Falló al actualizar el ítem: ${failure.message}'),
      ),
      (_) {}, // En caso de éxito, no hacemos nada; el stream se encarga.
    );
  }

  Future<void> transferItem({
    required ItemModel updatedItem,
    required List<InventoryMovementModel> movements,
  }) async {
    debugPrint('--- INICIO TRANSFER ITEM ---');
    if (movements.isEmpty) return;

    // Extraer customerId del primer movimiento (todos deben tener el mismo)
    final customerId = movements.first.customerId;
    final itemId = updatedItem.id;
    final quantityTransferred = movements.length.toDouble();
    debugPrint(
      'Transferir $quantityTransferred items ($itemId) a cliente $customerId',
    );

    // 1. Actualizar el item (restar cantidad)
    final updateResult = await updateItemUseCase(updatedItem);

    await updateResult.fold(
      (failure) {
        debugPrint('ERROR: Falló al actualizar item: ${failure.message}');
        emit(
          ItemsPageError('Falló al actualizar el ítem: ${failure.message}'),
        );
      },
      (_) async {
        debugPrint(
          'Item actualizado correctamente. Consultando inventario cliente...',
        );
        // 2. Verificar si el cliente ya tiene este item (producto)
        // Como GetCustomerProducts devuelve un Stream, tomamos el primer valor.
        // Esto no es ideal para alta concurrencia pero sirve para este caso.
        final productsStream = getCustomerProducts(customerId);
        final productsEither = await productsStream.first;

        await productsEither.fold(
          (failure) {
            debugPrint(
              'ERROR: Falló al consultar productos cliente: ${failure.message}',
            );
            emit(
              ItemsPageError(
                'Error al consultar inventario del cliente: ${failure.message}',
              ),
            );
          },
          (customerProducts) async {
            // Buscar si ya existe un producto con este itemId (productId)
            // Asumimos que para items (repuestos), usamos productId = itemId
            final existingProductIndex = customerProducts.indexWhere(
              (p) =>
                  p.productId == itemId &&
                  p.productStatus == CustomerProductStatus.inventory,
            );

            if (existingProductIndex != -1) {
              debugPrint('Actualizando producto existente en cliente...');
              final existingProduct = customerProducts[existingProductIndex];
              final updatedProduct = existingProduct.copyWith(
                quantityRemaining: (existingProduct.quantityRemaining ?? 0) +
                    quantityTransferred,
                updatedAt: Timestamp.now(),
              );

              final updateResult = await updateCustomerProduct(updatedProduct);
              updateResult.fold(
                (failure) {
                  debugPrint(
                    'ERROR: Falló al actualizar producto cliente: ${failure.message}',
                  );
                  emit(
                    ItemsPageError(
                      'Error al actualizar producto del cliente: ${failure.message}',
                    ),
                  );
                },
                (_) => debugPrint('Producto cliente actualizado exitosamente.'),
              );
            } else {
              debugPrint('Creando nuevo registro de producto en cliente...');
              final newProduct = CustomerProductModel(
                id: '',
                customerId: customerId,
                productId: itemId,
                installedAt: DateTime.now(),
                productStatus: CustomerProductStatus.inventory,
                quantityProvided: quantityTransferred,
                quantityRemaining: quantityTransferred,
                createdAt: Timestamp.now(),
              );

              final addResult = await addCustomerProduct(newProduct);
              addResult.fold(
                (failure) {
                  debugPrint(
                    'ERROR: Falló al crear producto cliente: ${failure.message}',
                  );
                  emit(
                    ItemsPageError(
                      'Error al crear producto del cliente: ${failure.message}',
                    ),
                  );
                },
                (_) =>
                    debugPrint('Nuevo producto cliente creado exitosamente.'),
              );
            }

            // 4. Registrar los movimientos individuales
            debugPrint('Registrando ${movements.length} movimientos...');
            for (final movement in movements) {
              final movementResult = await addInventoryMovement(movement);
              movementResult.fold(
                (failure) {
                  debugPrint(
                    'ERROR: Falló al registrar movimiento: ${failure.message}',
                  );
                  emit(
                    ItemsPageError(
                      'Error al registrar movimiento: ${failure.message}',
                    ),
                  );
                },
                (_) {},
              );
            }
            debugPrint('--- FIN TRANSFER ITEM ---');
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
