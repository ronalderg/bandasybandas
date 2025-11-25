import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum genérico para representar el estado de una entidad en la base de datos.
enum EntityStatus {
  draft, // Borrador, no visible para producción.
  active, // Activo y listo para ser usado.
  archived, // Archivado, no se usa pero se mantiene en el historial.
  deleted, // Marcado como eliminado (soft delete).
  pending, // Pendiente de revisión o aprobación.
  sold, // Vendido o trasladado.
}

/// Mixin para añadir campos de metadatos comunes a los modelos.
///
/// Proporciona `status`, `createdAt`, y `updatedAt` para el seguimiento
/// del ciclo de vida de una entidad.
mixin EntityMetadata {
  /// Estado de la entidad (ej. activo, borrador, eliminado).
  abstract final EntityStatus status;

  /// Fecha y hora de creación de la entidad.
  abstract final Timestamp? createdAt;

  /// Fecha y hora de la última actualización de la entidad.
  abstract final Timestamp? updatedAt;

  /// Keys para la serialización en Firestore.
  static const statusKey = 'status';
  static const createdAtKey = 'createdAt';
  static const updatedAtKey = 'updatedAt';

  /// Devuelve los metadatos como un mapa para ser incluido en `toJson`.
  Map<String, dynamic> metadataToJson() => {
        statusKey: status.name,
        createdAtKey: createdAt,
        updatedAtKey: updatedAt,
      };
}
