import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar un item en la base de datos.
///
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
class ItemModel extends Equatable {
  /// Constructor para crear una instancia de [ItemModel].

  const ItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.price,
    this.description,
    this.imageUrl,
  });

  /// Factory constructor para crear una instancia de [ItemModel] desde un [DocumentSnapshot].
  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }
    return ItemModel(
      id: doc.id,
      name: data[nameKey] as String,
      sku: data[skuKey] as String,
      quantity: (data[quantityKey] as num).toDouble(),
      price: (data[priceKey] as num).toDouble(),
      description: data[descriptionKey] as String?,
      imageUrl: data[imageUrlKey] as String?,
    );
  }

  ///Keys
  static const nameKey = 'name';
  static const skuKey = 'sku';
  static const descriptionKey = 'description';
  static const quantityKey = 'quantity';
  static const priceKey = 'price';
  static const imageUrlKey = 'imageUrl';

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

  /// Convierte la instancia de [ItemModel] a un mapa JSON.
  /// El `id` no se incluye porque es el ID del documento en Firestore.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
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
      ];

  @override
  bool get stringify => true;
}
