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
