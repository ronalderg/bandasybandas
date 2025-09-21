// lib/src/app/bloc/auth/auth_state.dart
part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user = AppUser.empty,
  });

  const AuthState.authenticated(AppUser user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated, user: AppUser.empty);

  final AuthStatus status;
  final AppUser user;

  @override
  List<Object?> get props => [status, user];
}
