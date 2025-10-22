import 'package:bandasybandas/src/shared/models/user.dart';

/// Interfaz abstracta para la fuente de datos de los Users.
///
/// Define los métodos que deben ser implementados por cualquier datasource
/// que gestione los Users, como obtener, crear, actualizar o eliminar.
abstract class UsersDatasource {
  /// Obtiene un stream de la lista de Users desde la fuente de datos.
  Stream<List<AppUser>> getUsers();

  /// Agrega un nuevo User a la fuente de datos.
  Future<void> addUser(AppUser user);
}
