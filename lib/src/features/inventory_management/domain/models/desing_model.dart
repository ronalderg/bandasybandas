import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar un item dentro de una receta, con su cantidad.
class RecipeItem extends Equatable {
  const RecipeItem({
    required this.itemId,
    required this.quantity,
  });

  /// Factory para crear desde un mapa (ej. de Firestore).
  factory RecipeItem.fromMap(Map<String, dynamic> map) {
    return RecipeItem(
      itemId: map['itemId'] as String,
      quantity: (map['quantity'] as num).toDouble(),
    );
  }

  /// ID del documento del Item en la colección de inventario.
  final String itemId;

  /// Cantidad del item necesaria para esta receta (puede ser fraccional).
  final double quantity;

  /// Convierte la instancia a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'quantity': quantity,
    };
  }

  @override
  List<Object> get props => [itemId, quantity];
}

/// Modelo para representar una receta o diseño.
class RecipeModel extends Equatable with EntityMetadata {
  const RecipeModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.urlPdf,
    this.sku = '',
    this.items = const [],
    this.salePrice,
    this.status = EntityStatus.draft,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia de [RecipeModel] desde un [DocumentSnapshot].
  factory RecipeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }

    final itemsList = (data['items'] as List<dynamic>?) ?? [];
    final items = itemsList
        .map((item) => RecipeItem.fromMap(item as Map<String, dynamic>))
        .toList();

    // Convierte el string del status guardado en Firestore al enum RecipeStatus.
    // Usa 'draft' como valor por defecto si no se encuentra o es nulo.
    final statusString = data[EntityMetadata.statusKey] as String? ?? 'draft';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.draft,
    );

    return RecipeModel(
      id: doc.id,
      name: data[keyName] as String,
      description: data[keyDescription] as String?,
      imageUrl: data[keyImageUrl] as String?,
      sku: data[keySku] as String? ?? '',
      urlPdf: data[keyUrlPdf] as String?,
      salePrice: (data[keySalePrice] as num?)?.toDouble(),
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
      items: items,
    );
  }

  static const keyName = 'name';
  static const keyDescription = 'description';
  static const keyImageUrl = 'imageUrl';
  static const keyUrlPdf = 'urlPdf';
  static const keySku = 'sku';
  static const keyItems = 'items';
  static const keySalePrice = 'salePrice';

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? urlPdf;
  final String sku;
  final List<RecipeItem> items;
  final double? salePrice;
  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      keyName: name,
      keyDescription: description,
      keyImageUrl: imageUrl,
      keyUrlPdf: urlPdf,
      keySku: sku,
      keySalePrice: salePrice,
      ...metadataToJson(),
      keyItems: items.map((item) => item.toMap()).toList(),
    };
  }

  RecipeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? urlPdf,
    String? sku,
    List<RecipeItem>? items,
    double? salePrice,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      urlPdf: urlPdf ?? this.urlPdf,
      sku: sku ?? this.sku,
      items: items ?? this.items,
      salePrice: salePrice ?? this.salePrice,
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
        imageUrl,
        urlPdf,
        sku,
        items,
        salePrice,
        status,
        createdAt,
        updatedAt,
      ];
}
