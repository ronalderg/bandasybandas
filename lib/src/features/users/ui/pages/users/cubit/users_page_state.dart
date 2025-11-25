import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UsersPageState extends Equatable {
  const UsersPageState();

  @override
  List<Object> get props => [];
}

class UsersPageInitial extends UsersPageState {}

class UsersPageLoading extends UsersPageState {}

class UsersPageLoaded extends UsersPageState {
  const UsersPageLoaded(this.users);
  final List<AppUser> users;

  @override
  List<Object> get props => [users];
}

class UsersPageError extends UsersPageState {
  const UsersPageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
