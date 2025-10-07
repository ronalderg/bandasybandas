import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/items_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/items/cubit/items_state.dart';
import 'package:bloc/bloc.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit({required this.getItems}) : super(ItemsPageInitial());

  final GetItems getItems;
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

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
