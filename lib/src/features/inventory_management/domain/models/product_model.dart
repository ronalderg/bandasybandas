import 'package:bandasybandas/src/shared/domain/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo de datos para un producto.
class ProductModel extends Equatable with EntityMetadata {
  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia de [ProductModel] desde un [DocumentSnapshot].
  factory ProductModel.fromFirestore(
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

    return ProductModel(
      id: doc.id,
      name: data[keyName] as String,
      description: data[keyDescription] as String?,
      price: (data[keyPrice] as num?)?.toDouble(),
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  final String id;
  final String name;
  final String? description;
  final double? price;

  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  static const keyName = 'name';
  static const keyDescription = 'description';
  static const keyPrice = 'price';

  /// Convierte un objeto [ProductModel] en un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      keyName: name,
      keyDescription: description,
      keyPrice: price,
      ...metadataToJson(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        status,
        createdAt,
        updatedAt,
      ];
}
