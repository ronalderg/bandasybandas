import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar un item en la base de datos.
///
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
class ItemModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [ItemModel].
  const ItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.price,
    this.description,
    this.imageUrl,
    this.observations,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
    this.lastPurchaseOrderId,
    this.supplierId,
  });

  /// Factory constructor para crear una instancia de [ItemModel] desde un [DocumentSnapshot].
  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }

    // Convierte el string del status guardado en Firestore al enum ItemStatus.
    // Usa 'active' como valor por defecto si no se encuentra o es nulo.
    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    return ItemModel(
      id: doc.id,
      name: data[nameKey] as String,
      sku: data[skuKey] as String,
      quantity: (data[quantityKey] as num).toDouble(),
      price: (data[priceKey] as num).toDouble(),
      description: data[descriptionKey] as String?,
      imageUrl: data[imageUrlKey] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
      lastPurchaseOrderId: data[lastPurchaseOrderIdKey] as String?,
      supplierId: data[supplierIdKey] as String?,
      observations: data[observationsKey] as String?,
    );
  }

  ///Keys
  static const nameKey = 'name';
  static const skuKey = 'sku';
  static const descriptionKey = 'description';
  static const quantityKey = 'quantity';
  static const priceKey = 'price';
  static const imageUrlKey = 'imageUrl';
  static const lastPurchaseOrderIdKey = 'lastPurchaseOrderId';
  static const supplierIdKey = 'supplierId';
  static const observationsKey = 'observations';

  static const lenghtKey = 'lenght';
  static const widthKey = 'width';
  static const heightKey = 'height';

  /// ID único del item (ID del documento en Firestore).
  final String id;

  /// Nombre del item.
  final String name;

  /// SKU (Stock Keeping Unit) para identificación única del producto.
  final String sku;

  /// Descripción opcional del item.
  final String? description;

  /// Cantidad disponible en inventario.
  final double quantity;

  /// Precio de venta del item.
  final double price;

  /// URL de la imagen del item.
  final String? imageUrl;

  /// Estado del item (ej. activo, borrador, eliminado).
  @override
  final EntityStatus status;

  /// Fecha y hora de creación del item.
  @override
  final Timestamp? createdAt;

  /// Fecha y hora de la última actualización del item.
  @override
  final Timestamp? updatedAt;

  /// ID de la última orden de compra asociada a este item.
  final String? lastPurchaseOrderId;

  /// ID del proveedor preferido para este item.
  final String? supplierId;

  /// Observaciones o notas adicionales sobre el item.
  final String? observations;

  /// Un item vacío que representa un item no existente o placeholder.
  static const ItemModel empty = ItemModel(
    id: '',
    name: '',
    sku: '',
    quantity: 0,
    price: 0,
  );

  /// Retorna `true` si el item es el item vacío.
  bool get isEmpty => this == empty;

  /// Retorna `true` si el item no es el item vacío.
  bool get isNotEmpty => this != empty;

  /// Convierte la instancia de [ItemModel] a un mapa JSON.
  /// El `id` no se incluye porque es el ID del documento en Firestore.
  Map<String, dynamic> toJson() {
    return {
      nameKey: name,
      skuKey: sku,
      descriptionKey: description,
      quantityKey: quantity,
      priceKey: price,
      imageUrlKey: imageUrl,
      ...metadataToJson(), // Añade los campos del mixin
      lastPurchaseOrderIdKey: lastPurchaseOrderId,
      supplierIdKey: supplierId,
      observationsKey: observations,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        description,
        quantity,
        price,
        imageUrl,
        status,
        createdAt,
        updatedAt,
        lastPurchaseOrderId,
        supplierId,
        observations,
      ];

  @override
  bool get stringify => true;

  ItemModel copyWith({
    String? id,
    String? name,
    String? sku,
    double? quantity,
    double? price,
    String? description,
    String? imageUrl,
    String? observations,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? lastPurchaseOrderId,
    String? supplierId,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      observations: observations ?? this.observations,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastPurchaseOrderId: lastPurchaseOrderId ?? this.lastPurchaseOrderId,
      supplierId: supplierId ?? this.supplierId,
    );
  }
}
