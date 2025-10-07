import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// TODO(username): hacer documentacion.
enum UserType {
  tecnico,
  asesorIndustrial,
  pmi,
  gerenteComercial,
  gerente,
  none
}

/// Modelo para representar un usuario en la aplicación.
///
/// Este modelo es inmutable y se utiliza en toda la aplicación para
/// representar al usuario autenticado y sus datos asociados.
class AppUser extends Equatable {
  const AppUser({
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

  /// Crea una instancia de `User` solo con la información básica de Firebase Auth.
  /// Útil como fallback si el documento de Firestore no existe.
  factory AppUser.fromFirebaseAuth(firebase_auth.User firebaseUser) {
    return AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
    );
  }

  /// Constructor factory para crear una instancia de `User` desde un mapa (JSON).
  /// Ideal para deserializar datos desde Firestore.
  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AppUser(
      id: doc.id,
      email: data[keyEmail] as String? ?? '',
      userType: data[keyUserType] as String?,
      firstName: data[keyFirstName] as String?,
      lastName: data[keyLastName] as String?,
      documentId: data[keyDocumentId] as String?,
      // Manejo seguro para listas que pueden ser nulas o de tipo incorrecto
      allowedCompanies: (data[keyAllowedCompanies] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      city: data[keyCity] as String?,
      branch: data[keyBranch] as String?,
    );
  }

  /// Llaves constantes
  static const keyEmail = 'email';
  static const keyUserType = 'userType';
  static const keyFirstName = 'firstName';
  static const keyLastName = 'lastName';
  static const keyDocumentId = 'documentId';
  static const keyAllowedCompanies = 'allowedCompanies';
  static const keyCity = 'city';
  static const keyBranch = 'branch';

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
  static const empty = AppUser(id: '', email: '');

  /// Retorna `true` si el usuario es el usuario vacío (no autenticado).
  bool get isEmpty => this == AppUser.empty;

  /// Retorna `true` si el usuario no está vacío (autenticado).
  bool get isNotEmpty => this != AppUser.empty;

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

  /// Crea una copia de la instancia actual con los campos proporcionados.
  AppUser copyWith({
    String? id,
    String? email,
    String? userType,
    String? firstName,
    String? lastName,
    String? documentId,
    List<String>? allowedCompanies,
    String? city,
    String? branch,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      documentId: documentId ?? this.documentId,
      allowedCompanies: allowedCompanies ?? this.allowedCompanies,
      city: city ?? this.city,
      branch: branch ?? this.branch,
    );
  }

  UserType getTipoUsuario() {
    switch (userType) {
      case 'Tecnico':
        return UserType.tecnico;
      case 'Asesor Industrial':
        return UserType.asesorIndustrial;
      case 'PMI':
        return UserType.pmi;
      case 'Gerente Comercial':
        return UserType.gerenteComercial;
      case 'Gerente':
        return UserType.gerente;
      default:
        return UserType.none;
    }
  }
}
