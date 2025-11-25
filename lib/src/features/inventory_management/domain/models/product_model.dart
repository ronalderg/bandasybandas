import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo de datos para un producto.
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
/// Extiende [EntityMetadata] para incluir metadatos comunes.
class ProductModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [ProductModel].
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.serial,
    required this.category,
    required this.quantity,
    this.description,
    this.price,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
    this.recipeId,
  });

  /// Factory constructor para crear una instancia de [ProductModel] desde un [DocumentSnapshot].
  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }

    final itemsList = (data[keyItems] as List<dynamic>?) ?? [];
    final items = itemsList
        .map((item) => RecipeItem.fromMap(item as Map<String, dynamic>))
        .toList();

    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    return ProductModel(
      id: doc.id,
      name: data[keyName] as String,
      sku: data[keySku] as String,
      serial: data[keySerial] as String,
      category: data[keyCategory] as String,
      quantity: (data[keyQuantity] as num).toDouble(),
      description: data[keyDescription] as String?,
      price: (data[keyPrice] as num?)?.toDouble(),
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
      items: items,
      recipeId: data[keyRecipeId] as String?,
    );
  }

  final String id;
  final String name;
  final String sku;
  final String serial;
  final String category;
  final double quantity;
  final String? description;
  final double? price;

  /// Lista de items (componentes) que conforman este producto.
  final List<RecipeItem> items;

  /// ID de la receta ([RecipeModel]) asociada a este producto.
  final String? recipeId;

  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  static const keyName = 'name';
  static const keyDescription = 'description';
  static const keyPrice = 'price';
  static const keySku = 'sku';
  static const keySerial = 'serial';
  static const keyCategory = 'category';
  static const keyQuantity = 'quantity';
  static const keyItems = 'items';
  static const keyRecipeId = 'recipeId';

  /// Convierte un objeto [ProductModel] en un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      keyName: name,
      keySku: sku,
      keySerial: serial,
      keyCategory: category,
      keyQuantity: quantity,
      keyDescription: description,
      keyPrice: price,
      keyItems: items.map((item) => item.toMap()).toList(),
      keyRecipeId: recipeId,
      ...metadataToJson(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? serial,
    String? category,
    double? quantity,
    String? description,
    double? price,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    List<RecipeItem>? items,
    String? recipeId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      serial: serial ?? this.serial,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      recipeId: recipeId ?? this.recipeId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        serial,
        category,
        quantity,
        description,
        price,
        status,
        createdAt,
        updatedAt,
        items,
        recipeId,
      ];
}
