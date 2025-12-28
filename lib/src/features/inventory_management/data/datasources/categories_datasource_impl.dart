import 'package:bandasybandas/src/features/inventory_management/data/datasources/categories_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [CategoriesDataSource] usando Firestore.
class CategoriesDataSourceImpl implements CategoriesDataSource {
  CategoriesDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  /// Nombre de la colección en Firestore.
  static const String _collectionName = 'categories';

  /// Referencia a la colección de categorías.
  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection(_collectionName);

  @override
  Stream<List<CategoryModel>> getCategories() {
    return _categoriesCollection
        .where(EntityMetadata.statusKey, isEqualTo: EntityStatus.active.name)
        .orderBy(CategoryModel.nameKey)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    final categoryData = category.toJson();

    // Agregar timestamps
    categoryData[EntityMetadata.createdAtKey] = FieldValue.serverTimestamp();
    categoryData[EntityMetadata.updatedAtKey] = FieldValue.serverTimestamp();

    await _categoriesCollection.add(categoryData);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final categoryData = category.toJson();

    // Actualizar timestamp
    categoryData[EntityMetadata.updatedAtKey] = FieldValue.serverTimestamp();

    await _categoriesCollection.doc(category.id).update(categoryData);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    // Soft delete: cambiar el status a deleted
    await _categoriesCollection.doc(categoryId).update({
      EntityMetadata.statusKey: EntityStatus.deleted.name,
      EntityMetadata.updatedAtKey: FieldValue.serverTimestamp(),
    });
  }
}
