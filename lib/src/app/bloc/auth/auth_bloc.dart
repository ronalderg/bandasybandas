import 'dart:async';

import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthState._()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);

    // Suscribirse al stream de usuarios del repositorio.
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<AppUser> _userSubscription;

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    // Si el usuario no está vacío, el estado es autenticado.
    // De lo contrario, es no autenticado.
    final newState = event.user.isNotEmpty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated();

    // Imprimimos el nuevo estado para depuración.
    // Esto es útil para ver qué estado se está enviando a la UI.
    debugPrint('AuthBloc: Emitting new state -> $newState');

    emit(newState);
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    // Simplemente llama al método de logout del repositorio.
    // El stream `user` se encargará de emitir un `User.empty` y actualizar el estado.
    _authenticationRepository.logOut();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
