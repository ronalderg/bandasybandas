import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:equatable/equatable.dart';

/// Clase base para los estados de la página de máquinas del cliente.
abstract class CustomerMachinesState extends Equatable {
  const CustomerMachinesState();

  @override
  List<Object> get props => [];
}

/// Estado inicial antes de cargar datos.
class CustomerMachinesInitial extends CustomerMachinesState {}

/// Estado mientras se están cargando las máquinas.
class CustomerMachinesLoading extends CustomerMachinesState {}

/// Estado cuando las máquinas se han cargado exitosamente.
class CustomerMachinesLoaded extends CustomerMachinesState {
  const CustomerMachinesLoaded({
    required this.customerProducts,
    required this.products,
  });

  final List<CustomerProductModel> customerProducts;
  final Map<String, ProductModel> products; // Map de productId -> ProductModel

  @override
  List<Object> get props => [customerProducts, products];
}

/// Estado cuando ocurre un error al cargar las máquinas.
class CustomerMachinesError extends CustomerMachinesState {
  const CustomerMachinesError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
