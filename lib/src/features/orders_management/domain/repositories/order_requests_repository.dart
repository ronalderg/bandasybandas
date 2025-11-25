import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de solicitudes de pedidos.
///
/// Define las operaciones que se pueden realizar sobre los datos de las solicitudes de pedidos,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class OrderRequestsRepository {
  /// Obtiene un stream de la lista de solicitudes de pedidos.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<OrderRequestModel>].
  Stream<Either<Failure, List<OrderRequestModel>>> getOrdersRequests();

  /// Agrega una nueva solicitud de pedido.
  Future<Either<Failure, void>> createOrderRequest(
    OrderRequestModel orderRequest,
  );

  /// Actualiza una solicitud de pedido existente.
  Future<Either<Failure, void>> updateOrderRequest(
    OrderRequestModel orderRequest,
  );

  /// Elimina una solicitud de pedido.
  Future<Either<Failure, void>> deleteOrderRequest(String id);
}
