import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:equatable/equatable.dart';

abstract class CustomersManagementState extends Equatable {
  const CustomersManagementState();

  @override
  List<Object> get props => [];
}

class CustomersPageInitial extends CustomersManagementState {}

class CustomersPageLoading extends CustomersManagementState {}

class CustomersPageLoaded extends CustomersManagementState {
  const CustomersPageLoaded(this.customers);
  final List<CustomerModel> customers;

  @override
  List<Object> get props => [customers];
}

class CustomersPageError extends CustomersManagementState {
  const CustomersPageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
