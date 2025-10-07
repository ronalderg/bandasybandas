import 'package:bandasybandas/src/features/authentication/domain/models/models.dart';
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bandasybandas/src/features/authentication/ui/pages/login/cubit/login_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      // No se emite un estado de éxito aquí. La navegación es manejada
      // globalmente por el AuthBloc, que escucha los cambios de autenticación.
      // Al navegar, esta página (y su cubit) se eliminarán, por lo que
      // emitir un nuevo estado causaría un error.
    } on LogInWithEmailAndPasswordFailure catch (e) {
      debugPrint('wyf?');
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          // Simplificamos el mensaje de error para el usuario
          errorMessage: e.message.replaceAll('Exception: ', ''),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          // Simplificamos el mensaje de error para el usuario
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
