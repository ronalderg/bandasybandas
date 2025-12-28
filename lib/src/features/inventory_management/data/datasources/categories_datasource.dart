import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';

/// Data source abstracto para categorías.
abstract class CategoriesDataSource {
  /// Obtiene un stream de todas las categorías activas.
  Stream<List<CategoryModel>> getCategories();

  /// Agrega una nueva categoría.
  Future<void> addCategory(CategoryModel category);

  /// Actualiza una categoría existente.
  Future<void> updateCategory(CategoryModel category);

  /// Elimina una categoría (soft delete).
  Future<void> deleteCategory(String categoryId);
}
