import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar una categoría de inventario.
///
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
class CategoryModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [CategoryModel].
  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.color,
    this.icon,
    this.status = EntityStatus.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia desde Firestore.
  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }

    final statusString = data[EntityMetadata.statusKey] as String? ?? 'active';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.active,
    );

    return CategoryModel(
      id: doc.id,
      name: data[nameKey] as String,
      description: data[descriptionKey] as String?,
      color: data[colorKey] as String?,
      icon: data[iconKey] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  /// Keys para Firestore
  static const nameKey = 'name';
  static const descriptionKey = 'description';
  static const colorKey = 'color';
  static const iconKey = 'icon';

  /// ID único de la categoría (ID del documento en Firestore).
  final String id;

  /// Nombre de la categoría.
  final String name;

  /// Descripción opcional de la categoría.
  final String? description;

  /// Color en formato hexadecimal (ej: '#FF5733') para representación visual.
  final String? color;

  /// Nombre del icono para representación visual.
  final String? icon;

  /// Estado de la categoría (activo, borrador, eliminado).
  @override
  final EntityStatus status;

  /// Fecha y hora de creación.
  @override
  final Timestamp? createdAt;

  /// Fecha y hora de la última actualización.
  @override
  final Timestamp? updatedAt;

  /// Categoría vacía (placeholder).
  static const CategoryModel empty = CategoryModel(
    id: '',
    name: '',
  );

  /// Retorna `true` si es la categoría vacía.
  bool get isEmpty => this == empty;

  /// Retorna `true` si no es la categoría vacía.
  bool get isNotEmpty => this != empty;

  /// Convierte la instancia a un mapa JSON para Firestore.
  Map<String, dynamic> toJson() {
    return {
      nameKey: name,
      descriptionKey: description,
      colorKey: color,
      iconKey: icon,
      ...metadataToJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        icon,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;

  /// Crea una copia de la categoría con los campos especificados actualizados.
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    String? icon,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
