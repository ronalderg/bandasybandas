import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/item_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/item_repository.dart';
import 'package:bandasybandas/src/features/orders_management/data/datasorces/order_requests_datasource.dart';
import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:bandasybandas/src/features/orders_management/domain/repositories/order_requests_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [ItemRepository] que utiliza [ItemDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class OrderRequestsRepositoryImpl implements OrderRequestsRepository {
  OrderRequestsRepositoryImpl(this.datasource);

  final OrderRequestsDatasource datasource;

  @override
  Stream<Either<Failure, List<OrderRequestModel>>> getOrdersRequests() async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final items in datasource.getOrdersRequests()) {
        yield Right(items);
      }
    } on FirebaseException catch (e) {
      // Si ocurre un error de Firebase, lo emite como un 'Left'.
      yield Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      // Captura cualquier otra excepción y la emite como un 'Left'.
      yield Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createOrderRequest(
    OrderRequestModel orderRequest,
  ) async {
    try {
      await datasource.createOrderRequest(orderRequest);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderRequest(
    OrderRequestModel orderRequest,
  ) async {
    try {
      await datasource.updateOrderRequest(orderRequest);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrderRequest(String id) async {
    try {
      await datasource.deleteOrderRequest(id);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
