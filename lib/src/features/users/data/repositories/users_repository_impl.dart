import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/users/data/datasources/users_datasource.dart';
import 'package:bandasybandas/src/features/users/domain/repositories/users_repository.dart';
import 'package:bandasybandas/src/shared/models/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

/// Implementación de [UsersRepository] que utiliza [UsersDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(this.datasource);

  final UsersDatasource datasource;

  @override
  Stream<Either<Failure, List<AppUser>>> getUsers() async* {
    try {
      // Escucha el stream del datasource y emite los datos como un 'Right'.
      await for (final items in datasource.getUsers()) {
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
  Future<Either<Failure, void>> addUser(AppUser user) async {
    try {
      final result = await datasource.addUser(user);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }
}
