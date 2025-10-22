import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/shared/models/user.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de usuarios.
///
/// Define las operaciones que se pueden realizar sobre los datos de los usuarios,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class UsersRepository {
  /// Obtiene un stream de la lista de usuarios.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<AppUser>].
  Stream<Either<Failure, List<AppUser>>> getUsers();

  /// Agrega un nuevo usuario.
  Future<Either<Failure, void>> addUser(AppUser user);
}
