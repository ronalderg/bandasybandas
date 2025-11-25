part of 'branches_cubit.dart';

abstract class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object> get props => [];
}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesLoaded extends BranchesState {
  const BranchesLoaded(this.branches);
  final List<BranchModel> branches;

  @override
  List<Object> get props => [branches];
}

class BranchesError extends BranchesState {
  const BranchesError(this.message);
  final String message;
}
