import 'dart:async';

import 'package:bandasybandas/src/shared/domain/repositories/branches_repository.dart';
import 'package:bandasybandas/src/shared/models/branch_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit({required BranchesRepository branchesRepository})
      : _branchesRepository = branchesRepository,
        super(BranchesInitial());

  final BranchesRepository _branchesRepository;

  Future<void> loadBranches() async {
    emit(BranchesLoading());

    // Llamamos al método que devuelve un Future.
    final eitherResult = await _branchesRepository.getBranches();

    // Usamos 'fold' para manejar el éxito (derecha) o el fracaso (izquierda).
    eitherResult.fold(
      (failure) => emit(BranchesError(failure.message)),
      (branches) => emit(BranchesLoaded(branches)),
    );
  }
}
