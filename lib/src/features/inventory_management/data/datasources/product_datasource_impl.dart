import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/product_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [ProductDatasource] que utiliza Firestore.
class ProductDatasourceImpl implements ProductDatasource {
  ProductDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _collectionPath = DbCollections.products;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Stream<List<ProductModel>> getProducts() {
    // Escucha los cambios en la colección, excluyendo los marcados como 'deleted'.
    return _collection
        .where(
          EntityMetadata.statusKey,
          isNotEqualTo: EntityStatus.deleted.name,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(ProductModel.fromFirestore).toList(),
        );
  }

  @override
  Stream<ProductModel?> getProductById(String id) {
    // Escucha los cambios en un documento específico por su ID.
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return ProductModel.fromFirestore(snapshot);
      }
      return null; // Retorna null si el documento no existe.
    });
  }

  @override
  Future<void> createProduct(ProductModel product) {
    final now = Timestamp.now();
    // Crea una copia de la receta con las fechas de creación y actualización.
    final newProduct = product.copyWith(createdAt: now, updatedAt: now);
    return _collection.add(newProduct.toJson());
  }

  @override
  Future<void> updateProduct(ProductModel product) {
    // Crea una copia con la fecha de actualización.
    final updatedProduct = product.copyWith(updatedAt: Timestamp.now());
    return _collection.doc(product.id).update(updatedProduct.toJson());
  }

  @override
  Future<void> deleteProduct(String id) {
    // Realiza un "soft delete" actualizando el estado y la fecha.
    return _collection.doc(id).update({
      EntityMetadata.statusKey: EntityStatus.deleted.name,
      EntityMetadata.updatedAtKey: Timestamp.now(),
    });
  }
}
