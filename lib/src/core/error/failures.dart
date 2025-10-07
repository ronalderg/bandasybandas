import 'package:equatable/equatable.dart';

/// Clase base abstracta para representar fallos en la aplicación.
///
/// Utiliza [Equatable] para permitir comparaciones de valor.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

/// Representa un fallo específico ocurrido durante una operación con Firestore.
class FirestoreFailure extends Failure {
  const FirestoreFailure(super.message);
}
