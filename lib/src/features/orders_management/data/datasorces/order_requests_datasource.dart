import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';

/// Interfaz abstracta para la fuente de datos de las solicitudes de pedidos.
///
/// Define los métodos que deben ser implementados por cualquier datasource
/// que gestione las solicitudes de pedidos, como obtener, crear, actualizar o eliminar.
abstract class OrderRequestsDatasource {
  /// Obtiene un stream de la lista de solicitudes de pedidos desde la fuente de datos.
  Stream<List<OrderRequestModel>> getOrdersRequests();

  /// Agrega una nueva solicitud de pedido a la fuente de datos.
  Future<void> createOrderRequest(OrderRequestModel orderRequest);

  /// Actualiza una solicitud de pedido existente en la fuente de datos.
  Future<void> updateOrderRequest(OrderRequestModel orderRequest);

  /// Elimina una solicitud de pedido de la fuente de datos.
  Future<void> deleteOrderRequest(String id);
}
