import 'package:bandasybandas/src/features/inventory_management/domain/models/recipe_model.dart';
import 'package:flutter/foundation.dart';

/// Interfaz abstracta para la fuente de datos de las recetas (diseños).
///
/// Define el contrato que deben seguir las implementaciones concretas (como
/// Firestore, una API REST, o una base de datos local) para interactuar con
/// los datos de las recetas.
abstract class RecipeDatasource {
  /// Obtiene un stream que emite la lista de todas las recetas.
  ///
  /// El stream se actualiza en tiempo real cada vez que hay un cambio
  /// en la fuente de datos (creación, actualización o eliminación).
  Stream<List<RecipeModel>> getRecipes();

  /// Crea una nueva receta en la fuente de datos.
  ///
  /// Lanza una excepción si la operación falla.
  Future<void> createRecipe(RecipeModel recipe);

  /// Actualiza una receta existente en la fuente de datos.
  ///
  /// El [recipe] debe contener el ID del documento a actualizar.
  /// Lanza una excepción si la operación falla.
  Future<void> updateRecipe(RecipeModel recipe);

  /// Elimina una receta de la fuente de datos, dado su [id].
  ///
  /// Dependiendo de la implementación, esto podría ser una eliminación
  /// física (hard delete) o lógica (soft delete).
  Future<void> deleteRecipe(String id);

  /// Sube un archivo PDF a la nube y retorna su URL de descarga.
  ///
  /// [fileData] son los bytes del archivo.
  /// [fileName] es el nombre que tendrá el archivo en el storage.
  Future<String> uploadPdf(Uint8List fileData, String fileName);
}
