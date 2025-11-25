import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:bandasybandas/src/features/orders_management/domain/usecases/order_requests_usecases.dart';
import 'package:bandasybandas/src/features/orders_management/ui/pages/orders_requests_detail/cubit/order_requests_page_state.dart';
import 'package:bloc/bloc.dart';

class OrderRequestsPageCubit extends Cubit<OrderRequestsPageState> {
  OrderRequestsPageCubit({
    required this.getOrdersRequests,
    required this.addOrderRequest,
  }) : super(OrdersRequestPageInitial());

  final GetOrderRequests getOrdersRequests;
  final AddOrderRequest addOrderRequest;
  StreamSubscription<List<OrderRequestModel>>? _ordersRequestsSubscription;

  Future<void> loadOrdersRequests() async {
    emit(OrdersRequestPageLoading());

    final result = await getOrdersRequests(NoParams());

    result.fold(
      (failure) => emit(
        OrdersRequestPageError(
          'Falló la carga inicial de solicitudes de pedido: ${failure.message}',
        ),
      ),
      (ordersRequestsStream) {
        _ordersRequestsSubscription?.cancel();
        _ordersRequestsSubscription =
            ordersRequestsStream.listen((ordersRequests) {
          emit(OrdersRequestPageLoaded(ordersRequests));
        });
      },
    );
  }

  Future<void> createOrderRequest(OrderRequestModel orderRequest) async {
    // No se emite un estado de carga aquí para no bloquear toda la UI.
    // La actualización de la lista se manejará por el stream.
    final result = await addOrderRequest(orderRequest);

    result.fold(
      (failure) => emit(
        OrdersRequestPageError(
          'Falló al agregar la solicitud de pedido: ${failure.message}',
        ),
      ),
      (_) {}, // En caso de éxito, no hacemos nada, el stream actualizará la UI.
    );
  }

  @override
  Future<void> close() {
    _ordersRequestsSubscription?.cancel();
    return super.close();
  }
}
