// lib/src/features/authentication/domain/models/password.dart
import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    // Firebase requiere al menos 6 caracteres.
    return value != null && value.length >= 6
        ? null
        : PasswordValidationError.invalid;
  }
}
