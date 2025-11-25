import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/users/domain/repositories/users_repository.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
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

/// Parámetros para el caso de uso [AddUser].
class AddUserParams {
  const AddUserParams({
    required this.user,
    required this.password,
  });

  final AppUser user;
  final String password;
}

/// Caso de uso para agregar un nuevo usuario.
///
/// Extiende de [UseCase] y requiere [AddUserParams] como parámetro.
class AddUser extends UseCase<void, AddUserParams> {
  AddUser(this.repository);
  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(AddUserParams params) {
    return repository.addUser(params.user, params.password);
  }
}

/// Caso de uso para actualizar un usuario existente.
///
/// Extiende de [UseCase] y requiere un [AppUser] como parámetro.
class UpdateUser extends UseCase<void, AppUser> {
  UpdateUser(this.repository);
  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(AppUser params) {
    return repository.updateUser(params);
  }
}

/// Caso de uso para eliminar un usuario por su ID.
///
/// Extiende de [UseCase] y requiere un [String] (userId) como parámetro.
class DeleteUser extends UseCase<void, String> {
  DeleteUser(this.repository);
  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteUser(params);
  }
}
