import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';

/// Interfaz abstracta para la fuente de datos de los productos.
///
/// Define el contrato que deben seguir las implementaciones concretas (como
/// Firestore, una API REST, o una base de datos local) para interactuar con
/// los datos de las recetas.
abstract class ProductDatasource {
  /// Obtiene un stream que emite la lista de todos los productos.
  ///
  /// El stream se actualiza en tiempo real cada vez que hay un cambio
  /// en la fuente de datos (creación, actualización o eliminación).
  Stream<List<ProductModel>> getProducts();

  /// Obtiene un stream que emite un único producto basado en su [id].
  ///
  /// El stream se actualiza si el producto cambia. Si el producto no se
  /// encuentra, el stream puede emitir `null`.
  Stream<ProductModel?> getProductById(String id);

  /// Crea un nuevo producto en la fuente de datos.
  ///
  /// Lanza una excepción si la operación falla.
  Future<void> createProduct(ProductModel product);

  /// Actualiza un producto existente en la fuente de datos.
  ///
  /// El [product] debe contener el ID del documento a actualizar.
  /// Lanza una excepción si la operación falla.
  Future<void> updateProduct(ProductModel product);

  /// Elimina un producto de la fuente de datos, dado su [id].
  ///
  /// Dependiendo de la implementación, esto podría ser una eliminación
  /// física (hard delete) o lógica (soft delete).
  Future<void> deleteProduct(String id);
}
