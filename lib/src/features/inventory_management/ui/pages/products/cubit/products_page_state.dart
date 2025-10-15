import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductsPageState extends Equatable {
  const ProductsPageState();

  @override
  List<Object> get props => [];
}

class ProductsPageInitial extends ProductsPageState {}

class ProductsPageLoading extends ProductsPageState {}

class ProductsPageLoaded extends ProductsPageState {
  const ProductsPageLoaded(this.products);

  final List<ProductModel> products;

  @override
  List<Object> get props => [products];
}

class ProductsPageError extends ProductsPageState {
  const ProductsPageError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
