import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:dartz/dartz.dart';

abstract class InventoryMovementRepository {
  Future<Either<Failure, void>> addMovement(InventoryMovementModel movement);
}
