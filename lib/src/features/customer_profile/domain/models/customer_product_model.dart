import 'package:bandasybandas/src/features/customer_profile/domain/models/usage_type.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo de datos para representar la relación entre un cliente y un producto (máquina).
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
/// Extiende [EntityMetadata] para incluir metadatos comunes.
class CustomerProductModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [CustomerProductModel].
  const CustomerProductModel({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.installedAt,
    this.serialNumber,
    this.location,
    this.removedAt,
    this.productStatus = CustomerProductStatus.transferred,
    this.quantityProvided,
    this.quantityRemaining,
    this.replacesProductId,
    this.replacedByProductId,
    this.technicalServiceIds = const [],
    this.notes,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia desde un [DocumentSnapshot] de Firestore.
  factory CustomerProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError(
        '¡El snapshot de Firestore para customer_product no tiene datos!',
      );
    }

    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    final productStatusString =
        data[keyProductStatus] as String? ?? 'transferred';
    final productStatus = CustomerProductStatus.values.firstWhere(
      (e) => e.name == productStatusString,
      orElse: () => CustomerProductStatus.transferred,
    );

    final technicalServiceIdsList =
        (data[keyTechnicalServiceIds] as List<dynamic>?) ?? [];
    final technicalServiceIds =
        technicalServiceIdsList.map((id) => id as String).toList();

    return CustomerProductModel(
      id: doc.id,
      customerId: data[keyCustomerId] as String,
      productId: data[keyProductId] as String,
      installedAt: (data[keyInstalledAt] as Timestamp).toDate(),
      serialNumber: data[keySerialNumber] as String?,
      location: data[keyLocation] as String?,
      removedAt: (data[keyRemovedAt] as Timestamp?)?.toDate(),
      productStatus: productStatus,
      quantityProvided: (data[keyQuantityProvided] as num?)?.toDouble(),
      quantityRemaining: (data[keyQuantityRemaining] as num?)?.toDouble(),
      replacesProductId: data[keyReplacesProductId] as String?,
      replacedByProductId: data[keyReplacedByProductId] as String?,
      technicalServiceIds: technicalServiceIds,
      notes: data[keyNotes] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  // --- Propiedades del Modelo ---

  final String id;
  final String customerId;
  final String productId;

  /// Número de serie específico de esta unidad de producto.
  final String? serialNumber;

  /// Fecha de instalación del producto en el cliente.
  final DateTime installedAt;

  /// Fecha de remoción/desinstalación del producto (null si aún está activo).
  final DateTime? removedAt;

  /// Ubicación de la máquina en el cliente.
  final String? location;

  /// Estado del producto en el cliente.
  final CustomerProductStatus productStatus;

  /// Cantidad inicial proporcionada (para stock de repuestos).
  final double? quantityProvided;

  /// Cantidad restante (para stock de repuestos).
  final double? quantityRemaining;

  /// ID del producto que este reemplaza (si es un reemplazo).
  final String? replacesProductId;

  /// ID del producto que reemplazó a este (si fue reemplazado).
  final String? replacedByProductId;

  /// Lista de IDs de servicios técnicos relacionados con este producto.
  final List<String> technicalServiceIds;

  /// Notas adicionales sobre el producto.
  final String? notes;

  @override
  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  // --- Constantes para las claves de Firestore ---
  static const keyCustomerId = 'customerId';
  static const keyProductId = 'productId';
  static const keySerialNumber = 'serialNumber';
  static const keyInstalledAt = 'installedAt';
  static const keyRemovedAt = 'removedAt';
  static const keyLocation = 'location';
  static const keyProductStatus = 'productStatus';
  static const keyQuantityProvided = 'quantityProvided';
  static const keyQuantityRemaining = 'quantityRemaining';
  static const keyReplacesProductId = 'replacesProductId';
  static const keyReplacedByProductId = 'replacedByProductId';
  static const keyTechnicalServiceIds = 'technicalServiceIds';
  static const keyNotes = 'notes';

  /// Convierte el objeto [CustomerProductModel] a un mapa JSON para Firestore.
  Map<String, dynamic> toJson() {
    return {
      keyCustomerId: customerId,
      keyProductId: productId,
      keySerialNumber: serialNumber,
      keyInstalledAt: Timestamp.fromDate(installedAt),
      keyRemovedAt: removedAt != null ? Timestamp.fromDate(removedAt!) : null,
      keyLocation: location,
      keyProductStatus: productStatus.name,
      keyQuantityProvided: quantityProvided,
      keyQuantityRemaining: quantityRemaining,
      keyReplacesProductId: replacesProductId,
      keyReplacedByProductId: replacedByProductId,
      keyTechnicalServiceIds: technicalServiceIds,
      keyNotes: notes,
      ...metadataToJson(), // Note: metadataToJson uses 'status' key for EntityStatus, we might need to override or be careful if we want to use 'status' for CustomerProductStatus.
      // Actually, EntityMetadata uses 'status' key. I should rename CustomerProductStatus field to avoid collision or rename EntityStatus field.
      // The user asked for specific states: trasladado/inventario/en uso/desechado/mantenimiento.
      // I will use 'productStatus' for the new enum to avoid collision with EntityMetadata 'status'.
      // Wait, I already renamed usageType to status in previous chunks.
      // Let's rename the new field to productStatus to be safe and clear, or keep it as status and rename EntityStatus to entityStatus.
      // I'll rename EntityStatus field to entityStatus in this model to avoid confusion, but EntityMetadata expects 'status' in json.
      // I will use 'productStatus' for the CustomerProductStatus to avoid conflict with EntityMetadata.status.
    };
  }

  /// Crea una copia de la instancia actual con los campos proporcionados.
  CustomerProductModel copyWith({
    String? id,
    String? customerId,
    String? productId,
    String? serialNumber,
    DateTime? installedAt,
    DateTime? removedAt,
    String? location,
    CustomerProductStatus? productStatus,
    double? quantityProvided,
    double? quantityRemaining,
    String? replacesProductId,
    String? replacedByProductId,
    List<String>? technicalServiceIds,
    String? notes,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return CustomerProductModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      serialNumber: serialNumber ?? this.serialNumber,
      installedAt: installedAt ?? this.installedAt,
      removedAt: removedAt ?? this.removedAt,
      location: location ?? this.location,
      productStatus: productStatus ?? this.productStatus,
      quantityProvided: quantityProvided ?? this.quantityProvided,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      replacesProductId: replacesProductId ?? this.replacesProductId,
      replacedByProductId: replacedByProductId ?? this.replacedByProductId,
      technicalServiceIds: technicalServiceIds ?? this.technicalServiceIds,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        productId,
        serialNumber,
        installedAt,
        removedAt,
        location,
        productStatus,
        quantityProvided,
        quantityRemaining,
        replacesProductId,
        replacedByProductId,
        technicalServiceIds,
        notes,
        status,
        createdAt,
        updatedAt,
      ];
}
