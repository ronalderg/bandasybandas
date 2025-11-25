import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(this.product);
  final ProductModel product;

  @override
  List<Object> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
