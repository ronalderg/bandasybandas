import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:equatable/equatable.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsPageInitial extends ItemsState {}

class ItemsPageLoading extends ItemsState {}

class ItemsPageLoaded extends ItemsState {
  const ItemsPageLoaded(this.items);
  final List<ItemModel> items;

  @override
  List<Object> get props => [items];
}

class ItemsPageError extends ItemsState {
  const ItemsPageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
