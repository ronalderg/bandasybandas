import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo de datos para un cliente (empresa).
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
/// Extiende [EntityMetadata] para incluir metadatos comunes.
class CustomerModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [CustomerModel].
  const CustomerModel({
    required this.id,
    required this.name,
    this.nit,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.contactPerson,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia desde un [DocumentSnapshot] de Firestore.
  factory CustomerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError(
        '¡El snapshot de Firestore para el cliente no tiene datos!',
      );
    }

    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    return CustomerModel(
      id: doc.id,
      name: data[keyName] as String,
      nit: data[keyNit] as String?,
      email: data[keyEmail] as String?,
      phone: data[keyPhone] as String?,
      address: data[keyAddress] as String?,
      city: data[keyCity] as String?,
      contactPerson: data[keyContactPerson] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  // --- Propiedades del Modelo ---

  final String id;
  final String name;
  final String? nit; // NIT o Identificación Tributaria
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? contactPerson; // Persona de contacto en la empresa

  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  // --- Constantes para las claves de Firestore ---
  static const keyName = 'name';
  static const keyNit = 'nit';
  static const keyEmail = 'email';
  static const keyPhone = 'phone';
  static const keyAddress = 'address';
  static const keyCity = 'city';
  static const keyContactPerson = 'contactPerson';

  /// Convierte el objeto [CustomerModel] a un mapa JSON para Firestore.
  Map<String, dynamic> toJson() {
    return {
      keyName: name,
      keyNit: nit,
      keyEmail: email,
      keyPhone: phone,
      keyAddress: address,
      keyCity: city,
      keyContactPerson: contactPerson,
      ...metadataToJson(), // Añade los campos del mixin (status, createdAt, updatedAt)
    };
  }

  /// Crea una copia de la instancia actual con los campos proporcionados.
  CustomerModel copyWith({
    String? id,
    String? name,
    String? nit,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? contactPerson,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nit: nit ?? this.nit,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      contactPerson: contactPerson ?? this.contactPerson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nit,
        email,
        phone,
        address,
        city,
        contactPerson,
        status,
        createdAt,
        updatedAt,
      ];
}
