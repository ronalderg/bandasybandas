import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:equatable/equatable.dart';

/// Clase base para los estados de la página de inventario del cliente.
abstract class CustomerInventoryState extends Equatable {
  const CustomerInventoryState();

  @override
  List<Object> get props => [];
}

/// Estado inicial antes de cargar datos.
class CustomerInventoryInitial extends CustomerInventoryState {}

/// Estado mientras se está cargando el inventario.
class CustomerInventoryLoading extends CustomerInventoryState {}

/// Estado cuando el inventario se ha cargado exitosamente.
class CustomerInventoryLoaded extends CustomerInventoryState {
  const CustomerInventoryLoaded({
    required this.customerProducts,
    required this.products,
  });

  final List<CustomerProductModel> customerProducts;
  final Map<String, ProductModel> products; // Map de productId -> ProductModel

  @override
  List<Object> get props => [customerProducts, products];
}

/// Estado cuando ocurre un error al cargar el inventario.
class CustomerInventoryError extends CustomerInventoryState {
  const CustomerInventoryError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
