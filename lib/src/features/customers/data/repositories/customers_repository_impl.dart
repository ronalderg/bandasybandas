import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/customers/data/datasources/customers_datasource.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:bandasybandas/src/features/customers/domain/repositories/customers_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [CustomersRepository] que utiliza [CustomersDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl(this.datasource);

  final CustomersDatasource datasource;

  @override
  Stream<Either<Failure, List<CustomerModel>>> getCustomers() async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final items in datasource.getCustomers()) {
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
  Future<Either<Failure, void>> addCustomer(CustomerModel customer) async {
    try {
      final result = await datasource.addCustomer(customer);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }
}
