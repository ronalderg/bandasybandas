import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/users/domain/repositories/users_repository.dart';
import 'package:bandasybandas/src/shared/models/user.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de usuarios.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetUsers extends UseCase<Stream<List<AppUser>>, NoParams> {
  GetUsers(this.repository);
  final UsersRepository repository;

  @override
  Future<Either<Failure, Stream<List<AppUser>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getUsers().map(
            (either) => either.fold((failure) => [], (users) => users),
          ),
    );
  }
}

/// Caso de uso para agregar un nuevo usuario.
///
/// Extiende de [UseCase] y requiere un [AppUser] como parámetro.
class AddUser extends UseCase<void, AppUser> {
  AddUser(this.repository);
  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(AppUser params) {
    return repository.addUser(params);
  }
}
