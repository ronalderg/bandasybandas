import 'package:bandasybandas/src/core/error/failures.dart'
    show Failure, FirestoreFailure;
import 'package:bandasybandas/src/shared/data/datasources/branches_datasource.dart';
import 'package:bandasybandas/src/shared/domain/repositories/branches_repository.dart';
import 'package:bandasybandas/src/shared/models/branch_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'package:dartz/dartz.dart';

/// Implementación de [BranchesRepository] que utiliza [BranchesDatasource] para
/// obtener datos y maneja las excepciones convirtiéndolas en [Failure].
class BranchesRepositoryImpl implements BranchesRepository {
  BranchesRepositoryImpl(this.datasource);

  final BranchesDatasource datasource;

  @override
  Future<Either<Failure, List<BranchModel>>> getBranches() async {
    try {
      final items = await datasource.getBranches().first;
      return Right(items);
    } on FirebaseException catch (e) {
      // Si ocurre un error de Firebase, lo emite como un 'Left'.
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    } on Exception catch (e) {
      // Captura cualquier otra excepción y la emite como un 'Left'.
      return Left(FirestoreFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createBranch(BranchModel branch) async {
    try {
      final result = await datasource.createBranch(branch);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateBranch(BranchModel branch) async {
    try {
      final result = await datasource.updateBranch(branch);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteBranch(String id) async {
    try {
      final result = await datasource.deleteBranch(id);
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(
        FirestoreFailure(e.message ?? 'Error de Firestore desconocido'),
      );
    }
  }
}
