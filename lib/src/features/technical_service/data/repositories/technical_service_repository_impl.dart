import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/technical_service/data/datasources/technical_service_datasource.dart';
import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:bandasybandas/src/features/technical_service/domain/repositories/technical_service_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [TechnicalServiceRepository] que utiliza [TechnicalServiceDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class TechnicalServiceRepositoryImpl implements TechnicalServiceRepository {
  TechnicalServiceRepositoryImpl(this.datasource);

  final TechnicalServiceDatasource datasource;

  @override
  Stream<Either<Failure, List<TechnicalServiceModel>>>
      getTechnicalServices() async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final services in datasource.getTechnicalServices()) {
        yield Right(services);
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
  Future<Either<Failure, void>> addTechnicalService(
    TechnicalServiceModel service,
  ) async {
    try {
      final result = await datasource.addTechnicalService(service);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTechnicalService(
    TechnicalServiceModel service,
  ) async {
    try {
      final result = await datasource.updateTechnicalService(service);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }
}
