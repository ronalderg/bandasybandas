import 'package:bandasybandas/src/shared/models/branch_model.dart';

/// Interfaz abstracta para la fuente de datos de las Sucursales.
///
/// Define los métodos que deben ser implementados por cualquier datasource
/// que gestione las Sucursales, como obtener, crear, actualizar o eliminar.
abstract class BranchesDatasource {
  /// Obtiene un stream de la lista de Sucursales desde la fuente de datos.
  Stream<List<BranchModel>> getBranches();

  /// Crea una nueva Sucursal a la fuente de datos.
  Future<void> createBranch(BranchModel branch);

  /// Actualiza una Sucursal existente en la fuente de datos.
  Future<void> updateBranch(BranchModel branch);

  /// Elimina una Sucursal de la fuente de datos, dado su [id].
  Future<void> deleteBranch(String id);
}
