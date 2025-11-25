import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/inventory_movement_repository.dart';
import 'package:dartz/dartz.dart';

class AddInventoryMovement implements UseCase<void, InventoryMovementModel> {
  AddInventoryMovement(this.repository);

  final InventoryMovementRepository repository;

  @override
  Future<Either<Failure, void>> call(InventoryMovementModel params) {
    return repository.addMovement(params);
  }
}
