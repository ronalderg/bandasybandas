import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/customer_profile/data/datasources/customer_profile_datasource.dart';

import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/features/customer_profile/domain/repositories/customer_profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [CustomerProfileRepository] que utiliza [CustomerProfileDatasource]
/// para obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class CustomerProfileRepositoryImpl implements CustomerProfileRepository {
  CustomerProfileRepositoryImpl(this.datasource);

  final CustomerProfileDatasource datasource;

  @override
  Stream<Either<Failure, List<CustomerProductModel>>> getCustomerProducts(
    String customerId,
  ) async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final products in datasource.getCustomerProducts(customerId)) {
        yield Right(products);
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
  Future<Either<Failure, void>> addCustomerProduct(
    CustomerProductModel product,
  ) async {
    try {
      await datasource.addCustomerProduct(product);
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
  Future<Either<Failure, void>> updateCustomerProduct(
    CustomerProductModel product,
  ) async {
    try {
      await datasource.updateCustomerProduct(product);
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
