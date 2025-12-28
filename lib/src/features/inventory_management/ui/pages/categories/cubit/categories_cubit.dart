import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/category_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/categories_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/categories/cubit/categories_state.dart';
import 'package:bloc/bloc.dart';

/// Cubit para gestionar el estado de las categorías.
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required this.getCategories,
    required this.addCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoriesInitial());

  final GetCategories getCategories;
  final AddCategory addCategoryUseCase;
  final UpdateCategory updateCategoryUseCase;
  final DeleteCategory deleteCategoryUseCase;

  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;

  /// Carga las categorías desde Firestore.
  Future<void> loadCategories() async {
    emit(CategoriesLoading());

    final result = await getCategories(NoParams());

    result.fold(
      (failure) => emit(
        CategoriesError('Falló la carga de categorías: ${failure.message}'),
      ),
      (categoriesStream) {
        _categoriesSubscription?.cancel();
        _categoriesSubscription = categoriesStream.listen((categories) {
          emit(CategoriesLoaded(categories));
        });
      },
    );
  }

  /// Agrega una nueva categoría.
  Future<void> addCategory(CategoryModel category) async {
    final result = await addCategoryUseCase(category);

    result.fold(
      (failure) => emit(
        CategoriesError('Falló al agregar la categoría: ${failure.message}'),
      ),
      (_) {}, // El stream actualizará la UI automáticamente
    );
  }

  /// Actualiza una categoría existente.
  Future<void> updateCategory(CategoryModel category) async {
    final result = await updateCategoryUseCase(category);

    result.fold(
      (failure) => emit(
        CategoriesError('Falló al actualizar la categoría: ${failure.message}'),
      ),
      (_) {}, // El stream actualizará la UI automáticamente
    );
  }

  /// Elimina una categoría.
  Future<void> deleteCategory(String categoryId) async {
    final result = await deleteCategoryUseCase(categoryId);

    result.fold(
      (failure) => emit(
        CategoriesError('Falló al eliminar la categoría: ${failure.message}'),
      ),
      (_) {}, // El stream actualizará la UI automáticamente
    );
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
