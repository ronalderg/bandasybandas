import 'dart:typed_data';

import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/desing_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz para el repositorio de recetas (diseños).
///
/// Define el contrato que la capa de datos debe implementar para manejar
/// las operaciones CRUD de las recetas.
abstract class RecipeRepository {
  /// Obtiene un stream de la lista de items.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<ItemModel>].
  Stream<Either<Failure, List<RecipeModel>>> getRecipes();

  /// Agrega un nuevo item.
  Future<Either<Failure, void>> addRecipe(RecipeModel recipe);

  /// Sube un archivo PDF y retorna su URL.
  ///
  /// [fileData] son los bytes del archivo.
  /// [fileName] es el nombre que tendrá el archivo en el storage.
  Future<Either<Failure, String>> uploadPdf(
    Uint8List fileData,
    String fileName,
  );
}
