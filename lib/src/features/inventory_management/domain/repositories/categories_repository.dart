import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:dartz/dartz.dart';

/// Repositorio abstracto para gestionar categorías de inventario.
abstract class CategoriesRepository {
  /// Obtiene un stream de todas las categorías activas.
  Future<Either<Failure, Stream<List<CategoryModel>>>> getCategories();

  /// Agrega una nueva categoría.
  Future<Either<Failure, void>> addCategory(CategoryModel category);

  /// Actualiza una categoría existente.
  Future<Either<Failure, void>> updateCategory(CategoryModel category);

  /// Elimina una categoría (soft delete cambiando el status).
  Future<Either<Failure, void>> deleteCategory(String categoryId);
}
