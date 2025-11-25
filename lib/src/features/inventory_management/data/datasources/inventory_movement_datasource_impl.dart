import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/inventory_movement_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/inventory_movement_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryMovementDatasourceImpl implements InventoryMovementDatasource {
  InventoryMovementDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<void> addMovement(InventoryMovementModel movement) async {
    final collection = firestore.collection(DbCollections.inventoryMovements);
    // Usamos un ID generado automáticamente si viene vacío, o el que trae el modelo.
    // Como el modelo es inmutable y probablemente se crea con ID vacío antes de guardar,
    // dejamos que Firestore genere el ID.

    // Sin embargo, el modelo ya tiene un campo ID. Si pasamos un ID vacío,
    // Firestore creará el documento con ese ID vacío si usamos .doc('').set(...).
    // Lo mejor es usar .add() y dejar que Firestore asigne el ID, pero el modelo espera un ID.
    // En este caso, simplemente guardamos los datos.

    await collection.add(movement.toJson());
  }
}
