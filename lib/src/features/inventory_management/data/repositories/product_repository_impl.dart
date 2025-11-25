import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/product_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/product_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [ProductRepository] que utiliza [ProductDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this.datasource);

  final ProductDatasource datasource;

  @override
  Future<Either<Failure, Stream<ProductModel?>>> getProductById(
    String productId,
  ) async {
    try {
      final productStream = datasource.getProductById(productId);
      return Right(productStream);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

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

  @override
  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      await datasource.updateProduct(product);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await datasource.deleteProduct(id);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      return Left(FirestoreFailure(e.toString()));
    }
  }
}
