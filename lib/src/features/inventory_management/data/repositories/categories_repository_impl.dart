import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/categories_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/categories_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementación del repositorio de categorías.
class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(this.dataSource);

  final CategoriesDataSource dataSource;

  @override
  Future<Either<Failure, Stream<List<CategoryModel>>>> getCategories() async {
    try {
      final categoriesStream = dataSource.getCategories();
      return Right(categoriesStream);
    } catch (e) {
      return Left(FirestoreFailure('Error al obtener categorías: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(CategoryModel category) async {
    try {
      await dataSource.addCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure('Error al agregar categoría: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryModel category) async {
    try {
      await dataSource.updateCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure('Error al actualizar categoría: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String categoryId) async {
    try {
      await dataSource.deleteCategory(categoryId);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure('Error al eliminar categoría: $e'));
    }
  }
}
