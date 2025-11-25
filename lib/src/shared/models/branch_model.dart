import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar una sede o sucursal de la empresa.
///
/// Este modelo es inmutable y se utiliza para manejar la información
/// de las diferentes sedes.
class BranchModel extends Equatable with EntityMetadata {
  /// Constructor para la clase `Branch`.
  const BranchModel({
    required this.id,
    required this.address,
    required this.code,
    required this.name,
    required this.phone,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Constructor factory para crear una instancia de `Branch` desde un `DocumentSnapshot`.
  factory BranchModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return BranchModel.fromJson(doc.id, doc.data() ?? {});
  }

  /// Constructor factory para crear una instancia de `Branch` desde un mapa (JSON).
  /// Ideal para deserializar datos desde Firestore.
  factory BranchModel.fromJson(String id, Map<String, dynamic> data) {
    return BranchModel(
      id: id,
      address:
          data[keyAddress] as String? ?? '', // Valor por defecto si es nulo
      code: data[keyCode] as String? ?? '', // Valor por defecto si es nulo
      name: data[keyName] as String? ?? '', // Valor por defecto si es nulo
      phone: data[keyPhone] as String? ?? '', // Valor por defecto si es nulo
      status: EntityStatus.values.firstWhere(
        (e) =>
            e.name == (data[EntityMetadata.statusKey] as String? ?? 'active'),
        orElse: () => EntityStatus.active,
      ),
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  /// Una instancia de `BranchModel` vacía para representar un estado nulo o inicial.
  static const empty = BranchModel(
    id: '',
    address: '',
    code: '',
    name: '',
    phone: '',
  );

  /// Llaves constantes para los campos del modelo.
  static const keyAddress = 'address';
  static const keyCode = 'code';
  static const keyName = 'name';
  static const keyPhone = 'phone';

  /// El ID único de la sede (ID del documento en Firestore).
  final String id;

  /// La dirección física de la sede.
  final String address;

  /// Un código único para identificar la sede.
  final String code;

  /// El nombre de la sede (ej. "Cali", "Bogotá Principal").
  final String name;

  /// El número de teléfono de contacto de la sede.
  final String phone;

  @override
  final EntityStatus status;
  @override
  final Timestamp? createdAt;
  @override
  final Timestamp? updatedAt;

  /// Convierte la instancia de `Branch` a un mapa JSON.
  /// El `id` no se incluye porque es el ID del documento en Firestore.
  Map<String, dynamic> toJson() {
    return {
      keyAddress: address,
      keyCode: code,
      keyName: name,
      keyPhone: phone,
      ...metadataToJson(), // Añade los campos del mixin (status, createdAt, updatedAt)
    };
  }

  /// Crea una copia de la instancia actual con los campos proporcionados.
  BranchModel copyWith({
    String? id,
    String? address,
    String? code,
    String? name,
    String? phone,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      address: address ?? this.address,
      code: code ?? this.code,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        address,
        code,
        name,
        phone,
        status,
        createdAt,
        updatedAt,
      ];
}
