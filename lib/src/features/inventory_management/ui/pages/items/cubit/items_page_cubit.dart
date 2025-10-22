import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/items_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_page_state.dart';
import 'package:bloc/bloc.dart';

class ItemsCubit extends Cubit<ItemsPageState> {
  ItemsCubit({
    required this.getItems,
    required this.addItemUseCase,
  }) : super(ItemsPageInitial());

  final GetItems getItems;
  final AddItem addItemUseCase;
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

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
