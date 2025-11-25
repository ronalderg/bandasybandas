import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/shared/models/branch_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de sucursales.
///
/// Define las operaciones que se pueden realizar sobre los datos de las sucursales,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class BranchesRepository {
  /// Obtiene un Future de la lista de sucursales.
  Future<Either<Failure, List<BranchModel>>> getBranches();

  /// Crea una nueva sucursal.
  Future<Either<Failure, void>> createBranch(BranchModel branch);

  /// Actualiza una sucursal existente.
  Future<Either<Failure, void>> updateBranch(BranchModel branch);

  /// Elimina una sucursal.
  Future<Either<Failure, void>> deleteBranch(String id);
}
