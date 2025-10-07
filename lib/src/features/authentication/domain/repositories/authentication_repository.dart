// lib/src/features/authentication/domain/repositories/authentication_repository.dart
import 'package:bandasybandas/src/shared/models/user.dart';

/// Interfaz para el repositorio de autenticación.
/// Define el contrato que las capas superiores (UI, BLoC) usarán.
abstract class AuthenticationRepository {
  /// Stream que emite el usuario actual cuando cambia el estado de autenticación.
  Stream<AppUser> get user;

  /// Inicia sesión con email y contraseña.
  /// Lanza una excepción si falla.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Cierra la sesión del usuario actual.
  Future<void> logOut();
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'Emain no valido o mal formateado.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'Usuario desactivado. Por favor contacte a soporte.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'El Email ingresado no se encontró.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Contraseña incorrecta, por favor intente de nuevo.',
        );
      case 'invalid-credential':
        return const LogInWithEmailAndPasswordFailure(
          'Credenciales invalidos por favor intente de nuevo.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}
