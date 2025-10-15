import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de productos.
///
/// Define las operaciones que se pueden realizar sobre los datos de los productos,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class ProductRepository {
  /// Obtiene un stream de la lista de productos.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<ProductModel>].
  Stream<Either<Failure, List<ProductModel>>> getProducts();

  /// Agrega un nuevo producto.
  Future<Either<Failure, void>> addProduct(ProductModel product);
}
