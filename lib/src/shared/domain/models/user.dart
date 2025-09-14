import 'package:equatable/equatable.dart';

/// Modelo para representar un usuario en la aplicación.
///
/// Este modelo es inmutable y se utiliza en toda la aplicación para
/// representar al usuario autenticado y sus datos asociados.
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.userType,
    this.firstName,
    this.lastName,
    this.documentId,
    this.allowedCompanies,
    this.city,
    this.branch,
  });

  /// El ID único del usuario (ej. de Firebase Auth o de tu base de datos).
  final String id;

  /// El correo electrónico del usuario.
  final String email;

  /// El tipo o rol del usuario (ej. 'admin', 'supervisor', 'operario').
  final String? userType;

  /// Nombres del usuario.
  final String? firstName;

  /// Apellidos del usuario.
  final String? lastName;

  /// Documento de identidad del usuario.
  final String? documentId;

  /// Lista de IDs de empresas a las que el usuario tiene acceso.
  final List<String>? allowedCompanies;

  /// Ciudad del usuario.
  final String? city;

  /// Sede o sucursal a la que pertenece el usuario.
  final String? branch;

  /// Un usuario vacío que representa a un usuario no autenticado.
  static const empty = User(id: '', email: '');

  /// Retorna `true` si el usuario es el usuario vacío (no autenticado).
  bool get isEmpty => this == User.empty;

  /// Retorna `true` si el usuario no está vacío (autenticado).
  bool get isNotEmpty => this != User.empty;

  /// Propiedad computada para obtener el nombre completo.
  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  @override
  List<Object?> get props => [
        id,
        email,
        userType,
        firstName,
        lastName,
        documentId,
        allowedCompanies,
        city,
        branch,
      ];

  // También es muy recomendable añadir los métodos `copyWith`, `toJson` y `fromJson`
  // para facilitar la manipulación del estado y la serialización desde/hacia una API o base de datos.
  // Por brevedad, no los incluyo aquí, pero son una práctica estándar.
}
