import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum InventoryMovementType {
  transferOut, // Salida por traslado a cliente
  transferIn, // Entrada por devolución
  adjustment, // Ajuste de inventario
  sale, // Venta directa
}

class InventoryMovementModel extends Equatable with EntityMetadata {
  const InventoryMovementModel({
    required this.id,
    required this.itemId,
    required this.productId,
    required this.productSerial,
    required this.customerId,
    required this.type,
    required this.quantity,
    required this.date,
    this.userId,
    this.observations,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  factory InventoryMovementModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }

    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    final typeString = data['type'] as String? ?? 'transferOut';
    final type = InventoryMovementType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => InventoryMovementType.transferOut,
    );

    return InventoryMovementModel(
      id: doc.id,
      itemId: data['itemId'] as String,
      productId: data['productId'] as String,
      productSerial: data['productSerial'] as String,
      customerId: data['customerId'] as String,
      type: type,
      quantity: (data['quantity'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      userId: data['userId'] as String?,
      observations: data['observations'] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  final String id;
  final String itemId;
  final String productId;
  final String productSerial;
  final String customerId;
  final InventoryMovementType type;
  final double quantity;
  final DateTime date;
  final String? userId;
  final String? observations;

  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'productId': productId,
      'productSerial': productSerial,
      'customerId': customerId,
      'type': type.name,
      'quantity': quantity,
      'date': Timestamp.fromDate(date),
      'userId': userId,
      'observations': observations,
      ...metadataToJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        itemId,
        productId,
        productSerial,
        customerId,
        type,
        quantity,
        date,
        userId,
        observations,
        status,
        createdAt,
        updatedAt,
      ];
}
