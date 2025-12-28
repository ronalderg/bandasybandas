import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/categories_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener todas las categorías.
class GetCategories implements UseCase<Stream<List<CategoryModel>>, NoParams> {
  GetCategories(this.repository);

  final CategoriesRepository repository;

  @override
  Future<Either<Failure, Stream<List<CategoryModel>>>> call(
    NoParams params,
  ) async {
    return repository.getCategories();
  }
}

/// Caso de uso para agregar una nueva categoría.
class AddCategory implements UseCase<void, CategoryModel> {
  AddCategory(this.repository);

  final CategoriesRepository repository;

  @override
  Future<Either<Failure, void>> call(CategoryModel category) async {
    return repository.addCategory(category);
  }
}

/// Caso de uso para actualizar una categoría existente.
class UpdateCategory implements UseCase<void, CategoryModel> {
  UpdateCategory(this.repository);

  final CategoriesRepository repository;

  @override
  Future<Either<Failure, void>> call(CategoryModel category) async {
    return repository.updateCategory(category);
  }
}

/// Caso de uso para eliminar una categoría.
class DeleteCategory implements UseCase<void, String> {
  DeleteCategory(this.repository);

  final CategoriesRepository repository;

  @override
  Future<Either<Failure, void>> call(String categoryId) async {
    return repository.deleteCategory(categoryId);
  }
}
