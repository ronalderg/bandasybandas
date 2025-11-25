import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/shared/domain/repositories/branches_repository.dart';
import 'package:bandasybandas/src/shared/models/branch_model.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de Sucursales.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un `Future` de `Either` con la lista de sucursales.
class GetBranches extends UseCase<List<BranchModel>, NoParams> {
  GetBranches(this.repository);
  final BranchesRepository repository;

  @override
  Future<Either<Failure, List<BranchModel>>> call(
    NoParams params,
  ) async {
    return repository.getBranches();
  }
}

/// Caso de uso para agregar una nueva sucursal.
///
/// Extiende de [UseCase] y requiere un [BranchModel] como parámetro.
class AddBranch extends UseCase<void, BranchModel> {
  AddBranch(this.repository);
  final BranchesRepository repository;

  @override
  Future<Either<Failure, void>> call(BranchModel params) {
    return repository.createBranch(params);
  }
}

/// Caso de uso para actualizar una sucursal existente.
///
/// Extiende de [UseCase] y requiere un [BranchModel] como parámetro.
class UpdateBranch extends UseCase<void, BranchModel> {
  UpdateBranch(this.repository);
  final BranchesRepository repository;

  @override
  Future<Either<Failure, void>> call(BranchModel params) {
    return repository.updateBranch(params);
  }
}

/// Caso de uso para eliminar una sucursal.
///
class DeleteBranch extends UseCase<void, String> {
  DeleteBranch(this.repository);
  final BranchesRepository repository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteBranch(params);
  }
}
