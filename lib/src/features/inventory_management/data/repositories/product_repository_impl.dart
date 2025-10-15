import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/item_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/product_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/item_repository.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [ItemRepository] que utiliza [ItemDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this.datasource);

  final ProductDatasource datasource;

  @override
  Stream<Either<Failure, List<ProductModel>>> getProducts() async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final items in datasource.getProducts()) {
        yield Right(items);
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
  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      final result = await datasource.createProduct(product);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }
}
