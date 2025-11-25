import 'dart:typed_data';

import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz para el repositorio de recetas (diseños).
///
/// Define el contrato que la capa de datos debe implementar para manejar
/// las operaciones CRUD de las recetas.
abstract class RecipeRepository {
  /// Obtiene un stream de la lista de items.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<ItemModel>].
  Stream<Either<Failure, List<RecipeModel>>> getRecipes();

  /// Añade una nueva receta a la base de datos.
  Future<Either<Failure, void>> addRecipe(RecipeModel recipe);

  /// Actualiza una receta existente.
  Future<Either<Failure, void>> updateRecipe(RecipeModel recipe);

  /// Elimina una receta por su ID (soft delete).
  Future<Either<Failure, void>> deleteRecipe(String id);

  /// Sube un archivo PDF a Firebase Storage y devuelve su URL.
  Future<Either<Failure, String>> uploadPdf(
    Uint8List fileData,
    String fileName,
  );
}
