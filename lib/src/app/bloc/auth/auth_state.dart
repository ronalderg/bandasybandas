// lib/src/app/bloc/auth/auth_state.dart
part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.user,
  });

  const AuthState.authenticated(firebase_auth.User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final firebase_auth.User? user;

  @override
  List<Object?> get props => [status, user];
}
