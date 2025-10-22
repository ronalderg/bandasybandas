import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:equatable/equatable.dart';

abstract class ItemsPageState extends Equatable {
  const ItemsPageState();

  @override
  List<Object> get props => [];
}

class ItemsPageInitial extends ItemsPageState {}

class ItemsPageLoading extends ItemsPageState {}

class ItemsPageLoaded extends ItemsPageState {
  const ItemsPageLoaded(this.items);
  final List<ItemModel> items;

  @override
  List<Object> get props => [items];
}

class ItemsPageError extends ItemsPageState {
  const ItemsPageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
