// lib/src/app/bloc/auth/auth_bloc.dart
import 'dart:async';
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          // Estado inicial basado en si hay un usuario logueado al arrancar.
          authenticationRepository.currentUser != null
              ? AuthState.authenticated(authenticationRepository.currentUser!)
              : const AuthState.unauthenticated(),
        ) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);

    // Escucha los cambios en el estado de autenticación de Firebase.
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<firebase_auth.User?> _userSubscription;

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(
      event.user != null
          ? AuthState.authenticated(event.user!)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
