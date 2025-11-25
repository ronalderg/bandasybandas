import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar una solicitud de pedido.
///
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
/// Incluye metadatos de entidad a través del mixin [EntityMetadata].
class OrderRequestModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [OrderRequestModel].
  const OrderRequestModel({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.createdByUserId,
    this.customerName,
    this.createdByUserName,
    this.items = const [],
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    this.total = 0.0,
    this.paymentMethod,
    this.notes,
    this.deliveryAddress,
    this.warehouseId,
    this.source,
    this.deliveredAt,
    // Propiedades del mixin EntityMetadata
    this.status = EntityStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory para crear una instancia desde un [DocumentSnapshot] de Firestore.
  factory OrderRequestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError(
        '¡El snapshot de Firestore para la orden no tiene datos!',
      );
    }

    final itemsList = (data[keyItems] as List<dynamic>?) ?? [];
    final items = itemsList
        .map((item) => OrderItemModel.fromMap(item as Map<String, dynamic>))
        .toList();

    final statusString =
        data[EntityMetadata.statusKey] as String? ?? EntityStatus.pending.name;
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.pending,
    );

    return OrderRequestModel(
      id: doc.id,
      orderNumber: data[keyOrderNumber] as String? ?? '',
      customerId: data[keyCustomerId] as String? ?? '',
      customerName: data[keyCustomerName] as String?,
      createdByUserId: data[keyCreatedByUserId] as String? ?? '',
      createdByUserName: data[keyCreatedByUserName] as String?,
      items: items,
      subtotal: (data[keySubtotal] as num?)?.toDouble() ?? 0.0,
      tax: (data[keyTax] as num?)?.toDouble() ?? 0.0,
      discount: (data[keyDiscount] as num?)?.toDouble() ?? 0.0,
      total: (data[keyTotal] as num?)?.toDouble() ?? 0.0,
      paymentMethod: data[keyPaymentMethod] as String?,
      notes: data[keyNotes] as String?,
      deliveryAddress: data[keyDeliveryAddress] as String?,
      warehouseId: data[keyWarehouseId] as String?,
      source: data[keySource] as String?,
      deliveredAt: data[keyDeliveredAt] as Timestamp?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  // --- Propiedades del Modelo ---
  final String id;
  final String orderNumber; // Código legible o consecutivo del pedido
  final String customerId;
  final String? customerName; // Redundante pero útil para evitar joins
  final String createdByUserId;
  final String? createdByUserName;
  final List<OrderItemModel> items;
  final double? subtotal; // quitarnull POS Antes de impuestos y descuentos
  final double? tax;
  final double? discount;
  final double? total;
  final String? paymentMethod; // efectivo, tarjeta, crédito, etc.
  final String? notes;
  final String? deliveryAddress;
  final String? warehouseId;
  final String? source; // POS, Web, App móvil, etc.
  final Timestamp? deliveredAt;

  // --- Propiedades del mixin EntityMetadata ---
  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  // --- Constantes para las claves de Firestore ---
  static const keyOrderNumber = 'orderNumber';
  static const keyCustomerId = 'customerId';
  static const keyCustomerName = 'customerName';
  static const keyCreatedByUserId = 'createdByUserId';
  static const keyCreatedByUserName = 'createdByUserName';
  static const keyItems = 'items';
  static const keySubtotal = 'subtotal';
  static const keyTax = 'tax';
  static const keyDiscount = 'discount';
  static const keyTotal = 'total';
  static const keyPaymentMethod = 'paymentMethod';
  static const keyNotes = 'notes';
  static const keyDeliveryAddress = 'deliveryAddress';
  static const keyWarehouseId = 'warehouseId';
  static const keySource = 'source';
  static const keyDeliveredAt = 'deliveredAt';

  /// Convierte el objeto a un mapa JSON para Firestore.
  Map<String, dynamic> toJson() {
    return {
      keyOrderNumber: orderNumber,
      keyCustomerId: customerId,
      keyCustomerName: customerName,
      keyCreatedByUserId: createdByUserId,
      keyCreatedByUserName: createdByUserName,
      keyItems: items.map((item) => item.toMap()).toList(),
      keySubtotal: subtotal,
      keyTax: tax,
      keyDiscount: discount,
      keyTotal: total,
      keyPaymentMethod: paymentMethod,
      keyNotes: notes,
      keyDeliveryAddress: deliveryAddress,
      keyWarehouseId: warehouseId,
      keySource: source,
      keyDeliveredAt: deliveredAt,
      ...metadataToJson(), // Añade los campos del mixin
    };
  }

  /// Crea una copia de la instancia actual con los campos proporcionados.
  OrderRequestModel copyWith({
    String? id,
    String? orderNumber,
    String? customerId,
    String? customerName,
    String? createdByUserId,
    String? createdByUserName,
    List<OrderItemModel>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? total,
    String? paymentMethod,
    String? notes,
    String? deliveryAddress,
    String? warehouseId,
    String? source,
    Timestamp? deliveredAt,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return OrderRequestModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByUserName: createdByUserName ?? this.createdByUserName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      warehouseId: warehouseId ?? this.warehouseId,
      source: source ?? this.source,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        customerId,
        customerName,
        createdByUserId,
        createdByUserName,
        items,
        subtotal,
        tax,
        discount,
        total,
        paymentMethod,
        notes,
        deliveryAddress,
        warehouseId,
        source,
        deliveredAt,
        status,
        createdAt,
        updatedAt,
      ];
}

/// Modelo para representar un ítem dentro de una orden.
class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  /// Factory para crear desde un mapa (ej. de Firestore).
  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      itemId: map['itemId'] as String,
      itemName: map['itemName'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unitPrice: (map['unitPrice'] as num).toDouble(),
    );
  }

  final String itemId;
  final String itemName; // Redundante para mostrar en UI sin buscar el item
  final double quantity;
  final double unitPrice;

  /// Convierte la instancia a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  @override
  List<Object> get props => [itemId, itemName, quantity, unitPrice];
}
