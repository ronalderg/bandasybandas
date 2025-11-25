import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:bandasybandas/src/features/orders_management/domain/repositories/order_requests_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de items.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetOrderRequests
    extends UseCase<Stream<List<OrderRequestModel>>, NoParams> {
  GetOrderRequests(this.repository);
  final OrderRequestsRepository repository;

  @override
  Future<Either<Failure, Stream<List<OrderRequestModel>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getOrdersRequests().map(
            (either) => either.fold((failure) => [], (items) => items),
          ),
    );
  }
}

/// Caso de uso para agregar un nuevo item.
///
/// Extiende de [UseCase] y requiere un [OrderRequestModel] como parámetro.
class AddOrderRequest extends UseCase<void, OrderRequestModel> {
  AddOrderRequest(this.repository);
  final OrderRequestsRepository repository;

  @override
  Future<Either<Failure, void>> call(OrderRequestModel params) {
    return repository.createOrderRequest(params);
  }
}
