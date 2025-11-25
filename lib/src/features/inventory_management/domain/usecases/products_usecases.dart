import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de productos.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetProducts extends UseCase<Stream<List<ProductModel>>, NoParams> {
  GetProducts(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, Stream<List<ProductModel>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getProducts().map(
            (either) => either.fold((failure) => [], (products) => products),
          ),
    );
  }
}

/// {@template get_product_by_id_usecase}
/// Caso de uso para obtener un producto específico por su ID.
///
/// Este caso de uso actúa como un intermediario entre la capa de presentación
/// (Cubit/Bloc) y la capa de datos (Repositorio), encapsulando la lógica
/// para recuperar un solo producto.
///
/// Parámetros:
///   - `params`: El ID (`String`) del producto que se desea obtener.
///
/// Retorna:
///   - `Future<Either<Failure, Stream<ProductModel?>>>`: Un `Future` que resuelve a:
///     - `Right(Stream<ProductModel?>)`: En caso de éxito, devuelve un Stream
///       que emite el `ProductModel` cada vez que cambia en la base de datos.
///       El stream emitirá `null` si el producto con el ID especificado no se
///       encuentra.
///     - `Left(Failure)`: Si ocurre un error al intentar establecer la
///       conexión con la fuente de datos (p.ej., un error de red o permisos).
/// {@endtemplate}
class GetProductById extends UseCase<Stream<ProductModel?>, String> {
  GetProductById(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, Stream<ProductModel?>>> call(String params) {
    return repository.getProductById(params);
  }
}

/// Caso de uso para agregar un nuevo producto.
///
/// Extiende de [UseCase] y requiere un [ProductModel] como parámetro.
class AddProduct extends UseCase<void, ProductModel> {
  AddProduct(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, void>> call(ProductModel params) {
    return repository.addProduct(params);
  }
}

/// Caso de uso para actualizar un producto existente.
///
class UpdateProduct extends UseCase<bool, ProductModel> {
  UpdateProduct(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, bool>> call(ProductModel params) async {
    try {
      final result = await repository.updateProduct(params);
      return result.fold(
        Left.new,
        (_) => const Right(true),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}

/// Caso de uso para eliminar un producto por su ID.
///
class DeleteProduct extends UseCase<bool, String> {
  DeleteProduct(this.repository);
  final ProductRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) async {
    try {
      final result = await repository
          .deleteProduct(params); // params is already a String (id)
      return result.fold(
        Left.new,
        (_) => const Right(true),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
