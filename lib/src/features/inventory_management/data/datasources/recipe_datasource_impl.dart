import 'dart:typed_data';

import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/recipe_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/desing_model.dart';
import 'package:bandasybandas/src/shared/domain/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Implementación de [RecipeDatasource] que utiliza Firestore.
class RecipeDatasourceImpl implements RecipeDatasource {
  RecipeDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _collectionPath = DbCollections.recipes;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Stream<List<RecipeModel>> getRecipes() {
    // Escucha los cambios en la colección, excluyendo los marcados como 'deleted'.
    return _collection
        .where(
          EntityMetadata.statusKey,
          isNotEqualTo: EntityStatus.deleted.name,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(RecipeModel.fromFirestore).toList(),
        );
  }

  @override
  Future<void> createRecipe(RecipeModel recipe) {
    final now = Timestamp.now();
    // Crea una copia de la receta con las fechas de creación y actualización.
    final newRecipe = recipe.copyWith(createdAt: now, updatedAt: now);
    return _collection.add(newRecipe.toJson());
  }

  @override
  Future<void> updateRecipe(RecipeModel recipe) {
    // Crea una copia con la fecha de actualización.
    final updatedRecipe = recipe.copyWith(updatedAt: Timestamp.now());
    return _collection.doc(recipe.id).update(updatedRecipe.toJson());
  }

  @override
  Future<void> deleteRecipe(String id) {
    // Realiza un "soft delete" actualizando el estado y la fecha.
    return _collection.doc(id).update({
      EntityMetadata.statusKey: EntityStatus.deleted.name,
      EntityMetadata.updatedAtKey: Timestamp.now(),
    });
  }

  @override
  Future<String> uploadPdf(Uint8List fileData, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      // Usamos un ID único para evitar sobreescribir archivos
      final uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final pdfRef = storageRef.child('recipe_pdfs/$uniqueFileName');

      // Sube los datos del archivo
      final uploadTask = await pdfRef.putData(fileData);

      // Obtiene la URL de descarga
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Aquí puedes manejar errores de forma más específica
      throw Exception('Error al subir el PDF a Firebase Storage: $e');
    }
  }
}
