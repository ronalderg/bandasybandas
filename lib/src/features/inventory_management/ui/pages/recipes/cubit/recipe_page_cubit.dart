import 'dart:async';
import 'dart:typed_data';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/usecases/recipes_usecases.dart';
import 'package:bandasybandas/src/features/inventory_management/ui/pages/recipes/cubit/recipe_page_state.dart';
import 'package:bloc/bloc.dart';

class RecipesPageCubit extends Cubit<RecipesPageState> {
  RecipesPageCubit({
    required this.getRecipes,
    required this.addRecipe,
    required this.updateRecipe,
    required this.deleteRecipe,
    required this.uploadPdfUseCase,
  }) : super(RecipesPageInitial());

  final GetRecipes getRecipes;
  final AddRecipe addRecipe;
  final UpdateRecipe updateRecipe;
  final DeleteRecipe deleteRecipe;
  final UploadPdfUseCase uploadPdfUseCase;
  StreamSubscription<List<RecipeModel>>? _recipesSubscription;

  Future<void> loadRecipes() async {
    emit(RecipesPageLoading());
    final result = await getRecipes(NoParams());
    result.fold(
      (failure) =>
          emit(RecipesPageError('Error al cargar recetas: ${failure.message}')),
      (stream) {
        _recipesSubscription?.cancel();
        _recipesSubscription = stream.listen((recipes) {
          emit(RecipesPageLoaded(recipes));
        });
      },
    );
  }

  Future<void> createRecipe(RecipeModel recipe) async {
    final result = await addRecipe(recipe);
    result.fold(
      (failure) =>
          emit(RecipesPageError('Error al crear receta: ${failure.message}')),
      (_) {
        // No es necesario emitir un estado de éxito, el stream lo hará.
      },
    );
  }

  Future<String> uploadPdf(Uint8List fileData, String fileName) async {
    final result = await uploadPdfUseCase(
      UploadPdfParams(fileData: fileData, fileName: fileName),
    );

    return result.fold(
      (failure) {
        throw Exception('Error al subir PDF: ${failure.message}');
      },
      (url) => url,
    );
  }

  Future<void> updateExistingRecipe(RecipeModel recipe) async {
    final result = await updateRecipe(recipe);
    result.fold(
      (failure) => emit(
        RecipesPageError('Error al actualizar receta: ${failure.message}'),
      ),
      (_) {
        // El stream se encargará de actualizar la lista.
      },
    );
  }

  Future<void> deleteExistingRecipe(String recipeId) async {
    final result = await deleteRecipe(recipeId);
    result.fold(
      (failure) => emit(
        RecipesPageError('Error al eliminar receta: ${failure.message}'),
      ),
      (_) {
        // El stream se encargará de actualizar la lista.
      },
    );
  }

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    return super.close();
  }
}
