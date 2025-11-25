import 'dart:typed_data' show Uint8List;

import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/recipe_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Caso de uso para obtener la lista de recetas/diseños.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetRecipes extends UseCase<Stream<List<RecipeModel>>, NoParams> {
  GetRecipes(this.repository);
  final RecipeRepository repository;

  @override
  Future<Either<Failure, Stream<List<RecipeModel>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getRecipes().map(
            (either) => either.fold((failure) => [], (recipes) => recipes),
          ),
    );
  }
}

/// Caso de uso para agregar una nueva receta.
///
/// Extiende de [UseCase] y requiere un [RecipeModel] como parámetro.
class AddRecipe extends UseCase<void, RecipeModel> {
  AddRecipe(this.repository);
  final RecipeRepository repository;

  @override
  Future<Either<Failure, void>> call(RecipeModel params) {
    return repository.addRecipe(params);
  }
}

class UploadPdfUseCase implements UseCase<String, UploadPdfParams> {
  UploadPdfUseCase(this.repository);
  final RecipeRepository repository;

  @override
  Future<Either<Failure, String>> call(UploadPdfParams params) async {
    return repository.uploadPdf(params.fileData, params.fileName);
  }
}

class UploadPdfParams extends Equatable {
  const UploadPdfParams({required this.fileData, required this.fileName});
  final Uint8List fileData;
  final String fileName;

  @override
  List<Object?> get props => [fileData, fileName];
}

/// Caso de uso para actualizar una receta existente.
class UpdateRecipe extends UseCase<bool, RecipeModel> {
  UpdateRecipe(this.repository);
  final RecipeRepository repository;

  @override
  Future<Either<Failure, bool>> call(RecipeModel params) async {
    try {
      final result = await repository.updateRecipe(params);
      return result.fold(
        Left.new,
        (_) => const Right(true),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}

/// Caso de uso para eliminar una receta por su ID (soft delete).
class DeleteRecipe extends UseCase<bool, String> {
  DeleteRecipe(this.repository);
  final RecipeRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) async {
    try {
      final result = await repository.deleteRecipe(params);
      return result.fold(
        Left.new,
        (_) => const Right(true),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
