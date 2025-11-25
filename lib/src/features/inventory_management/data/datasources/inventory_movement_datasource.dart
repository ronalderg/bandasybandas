import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';

abstract class InventoryMovementDatasource {
  Future<void> addMovement(InventoryMovementModel movement);
}
