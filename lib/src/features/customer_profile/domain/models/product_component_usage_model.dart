import 'package:bandasybandas/src/features/customer_profile/domain/models/component_status.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo de datos para rastrear el uso de componentes individuales (items)
/// dentro de un producto/máquina instalado en un cliente.
///
/// Este modelo permite hacer seguimiento del ciclo de vida de cada componente,
/// incluyendo instalación, reemplazos, y vinculación con servicios técnicos.
class ProductComponentUsageModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [ProductComponentUsageModel].
  const ProductComponentUsageModel({
    required this.id,
    required this.customerProductId,
    required this.itemId,
    required this.installedAt,
    this.serialNumber,
    this.removedAt,
    this.componentStatus = ComponentStatus.active,
    this.replacesComponentId,
    this.replacedByComponentId,
    this.technicalServiceId,
    this.failureReason,
    this.notes,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia desde un [DocumentSnapshot] de Firestore.
  factory ProductComponentUsageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError(
        '¡El snapshot de Firestore para product_component_usage no tiene datos!',
      );
    }

    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    final componentStatusString =
        data[keyComponentStatus] as String? ?? 'active';
    final componentStatus = ComponentStatus.values.firstWhere(
      (e) => e.name == componentStatusString,
      orElse: () => ComponentStatus.active,
    );

    return ProductComponentUsageModel(
      id: doc.id,
      customerProductId: data[keyCustomerProductId] as String,
      itemId: data[keyItemId] as String,
      installedAt: (data[keyInstalledAt] as Timestamp).toDate(),
      serialNumber: data[keySerialNumber] as String?,
      removedAt: (data[keyRemovedAt] as Timestamp?)?.toDate(),
      componentStatus: componentStatus,
      replacesComponentId: data[keyReplacesComponentId] as String?,
      replacedByComponentId: data[keyReplacedByComponentId] as String?,
      technicalServiceId: data[keyTechnicalServiceId] as String?,
      failureReason: data[keyFailureReason] as String?,
      notes: data[keyNotes] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  // --- Propiedades del Modelo ---

  final String id;

  /// ID del producto/máquina al que pertenece este componente.
  final String customerProductId;

  /// ID del item (componente) del inventario.
  final String itemId;

  /// Número de serie específico de este componente (si aplica).
  final String? serialNumber;

  /// Fecha de instalación del componente.
  final DateTime installedAt;

  /// Fecha de remoción/reemplazo del componente (null si aún está activo).
  final DateTime? removedAt;

  /// Estado del componente (activo, reemplazado, removido, fallado).
  final ComponentStatus componentStatus;

  /// ID del componente que este reemplaza (si es un reemplazo).
  final String? replacesComponentId;

  /// ID del componente que reemplazó a este (si fue reemplazado).
  final String? replacedByComponentId;

  /// ID del servicio técnico relacionado con este componente.
  final String? technicalServiceId;

  /// Razón de falla o reemplazo del componente.
  final String? failureReason;

  /// Notas adicionales sobre el componente.
  final String? notes;

  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  // --- Constantes para las claves de Firestore ---
  static const keyCustomerProductId = 'customerProductId';
  static const keyItemId = 'itemId';
  static const keySerialNumber = 'serialNumber';
  static const keyInstalledAt = 'installedAt';
  static const keyRemovedAt = 'removedAt';
  static const keyComponentStatus = 'componentStatus';
  static const keyReplacesComponentId = 'replacesComponentId';
  static const keyReplacedByComponentId = 'replacedByComponentId';
  static const keyTechnicalServiceId = 'technicalServiceId';
  static const keyFailureReason = 'failureReason';
  static const keyNotes = 'notes';

  /// Convierte el objeto [ProductComponentUsageModel] a un mapa JSON para Firestore.
  Map<String, dynamic> toJson() {
    return {
      keyCustomerProductId: customerProductId,
      keyItemId: itemId,
      keySerialNumber: serialNumber,
      keyInstalledAt: Timestamp.fromDate(installedAt),
      keyRemovedAt: removedAt != null ? Timestamp.fromDate(removedAt!) : null,
      keyComponentStatus: componentStatus.name,
      keyReplacesComponentId: replacesComponentId,
      keyReplacedByComponentId: replacedByComponentId,
      keyTechnicalServiceId: technicalServiceId,
      keyFailureReason: failureReason,
      keyNotes: notes,
      ...metadataToJson(),
    };
  }

  /// Crea una copia de la instancia actual con los campos proporcionados.
  ProductComponentUsageModel copyWith({
    String? id,
    String? customerProductId,
    String? itemId,
    String? serialNumber,
    DateTime? installedAt,
    DateTime? removedAt,
    ComponentStatus? componentStatus,
    String? replacesComponentId,
    String? replacedByComponentId,
    String? technicalServiceId,
    String? failureReason,
    String? notes,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ProductComponentUsageModel(
      id: id ?? this.id,
      customerProductId: customerProductId ?? this.customerProductId,
      itemId: itemId ?? this.itemId,
      serialNumber: serialNumber ?? this.serialNumber,
      installedAt: installedAt ?? this.installedAt,
      removedAt: removedAt ?? this.removedAt,
      componentStatus: componentStatus ?? this.componentStatus,
      replacesComponentId: replacesComponentId ?? this.replacesComponentId,
      replacedByComponentId:
          replacedByComponentId ?? this.replacedByComponentId,
      technicalServiceId: technicalServiceId ?? this.technicalServiceId,
      failureReason: failureReason ?? this.failureReason,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerProductId,
        itemId,
        serialNumber,
        installedAt,
        removedAt,
        componentStatus,
        replacesComponentId,
        replacedByComponentId,
        technicalServiceId,
        failureReason,
        notes,
        status,
        createdAt,
        updatedAt,
      ];
}
