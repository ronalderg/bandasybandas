import 'dart:typed_data' show Uint8List;

import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/recipe_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/desing_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/recipe_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [RecipeRepository] que utiliza [RecipeDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this.datasource);

  final RecipeDatasource datasource;

  @override
  Stream<Either<Failure, List<RecipeModel>>> getRecipes() async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final recipes in datasource.getRecipes()) {
        yield Right(recipes);
      }
    } on FirebaseException catch (e) {
      // Si ocurre un error de Firebase, lo emite como un 'Left'.
      yield Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      // Captura cualquier otra excepción y la emite como un 'Left'.
      yield Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addRecipe(RecipeModel recipe) async {
    try {
      final result = await datasource.createRecipe(recipe);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadPdf(
    Uint8List fileData,
    String fileName,
  ) async {
    try {
      final url = await datasource.uploadPdf(fileData, fileName);
      return Right(url);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
