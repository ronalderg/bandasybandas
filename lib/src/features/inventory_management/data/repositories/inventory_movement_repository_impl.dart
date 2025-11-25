import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/inventory_movement_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/inventory_movement_repository.dart';
import 'package:dartz/dartz.dart';

class InventoryMovementRepositoryImpl implements InventoryMovementRepository {
  InventoryMovementRepositoryImpl(this.datasource);

  final InventoryMovementDatasource datasource;

  @override
  Future<Either<Failure, void>> addMovement(
    InventoryMovementModel movement,
  ) async {
    try {
      await datasource.addMovement(movement);
      return const Right(null);
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
