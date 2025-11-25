import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrderRequestsPageState extends Equatable {
  const OrderRequestsPageState();

  @override
  List<Object> get props => [];
}

class OrdersRequestPageInitial extends OrderRequestsPageState {}

class OrdersRequestPageLoading extends OrderRequestsPageState {}

class OrdersRequestPageLoaded extends OrderRequestsPageState {
  const OrdersRequestPageLoaded(this.ordersRequests);
  final List<OrderRequestModel> ordersRequests;

  @override
  List<Object> get props => [ordersRequests];
}

class OrdersRequestPageError extends OrderRequestsPageState {
  const OrdersRequestPageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
