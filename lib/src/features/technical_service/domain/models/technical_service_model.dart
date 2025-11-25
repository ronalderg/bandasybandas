import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Modelo para representar un servicio técnico en la base de datos.
///
/// Este modelo es inmutable y utiliza [Equatable] para facilitar las comparaciones.
class TechnicalServiceModel extends Equatable with EntityMetadata {
  /// Constructor para crear una instancia de [TechnicalServiceModel].
  const TechnicalServiceModel({
    required this.id,
    required this.serviceNumber,
    required this.clientName,
    required this.clientPhone,
    required this.reportedIssue,
    this.clientEmail,
    this.clientAddress,
    this.diagnosis,
    this.solution,
    this.technicianNotes,
    this.assignedTechnicianId,
    this.assignedTechnicianName,
    this.scheduledDate,
    this.completedDate,
    this.observations,
    this.status = EntityStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor para crear una instancia de [TechnicalServiceModel] desde un [DocumentSnapshot].
  factory TechnicalServiceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('¡El snapshot de Firestore no tiene datos!');
    }

    // Convierte el string del status guardado en Firestore al enum EntityStatus.
    // Usa 'pending' como valor por defecto si no se encuentra o es nulo.
    final statusString = data[EntityMetadata.statusKey] as String? ?? 'pending';
    final status = EntityStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => EntityStatus.pending,
    );

    return TechnicalServiceModel(
      id: doc.id,
      serviceNumber: data[serviceNumberKey] as String,
      clientName: data[clientNameKey] as String,
      clientPhone: data[clientPhoneKey] as String,
      clientEmail: data[clientEmailKey] as String?,
      clientAddress: data[clientAddressKey] as String?,
      reportedIssue: data[reportedIssueKey] as String,
      diagnosis: data[diagnosisKey] as String?,
      solution: data[solutionKey] as String?,
      technicianNotes: data[technicianNotesKey] as String?,
      assignedTechnicianId: data[assignedTechnicianIdKey] as String?,
      assignedTechnicianName: data[assignedTechnicianNameKey] as String?,
      scheduledDate: data[scheduledDateKey] as Timestamp?,
      completedDate: data[completedDateKey] as Timestamp?,
      observations: data[observationsKey] as String?,
      status: status,
      createdAt: data[EntityMetadata.createdAtKey] as Timestamp?,
      updatedAt: data[EntityMetadata.updatedAtKey] as Timestamp?,
    );
  }

  /// Keys para la serialización en Firestore
  static const serviceNumberKey = 'serviceNumber';
  static const clientNameKey = 'clientName';
  static const clientPhoneKey = 'clientPhone';
  static const clientEmailKey = 'clientEmail';
  static const clientAddressKey = 'clientAddress';
  static const reportedIssueKey = 'reportedIssue';
  static const diagnosisKey = 'diagnosis';
  static const solutionKey = 'solution';
  static const technicianNotesKey = 'technicianNotes';
  static const assignedTechnicianIdKey = 'assignedTechnicianId';
  static const assignedTechnicianNameKey = 'assignedTechnicianName';
  static const scheduledDateKey = 'scheduledDate';
  static const completedDateKey = 'completedDate';
  static const observationsKey = 'observations';

  /// ID único del servicio técnico (ID del documento en Firestore).
  final String id;

  /// Número de servicio para identificación (ej. ST-2024-001).
  final String serviceNumber;

  /// Nombre del cliente.
  final String clientName;

  /// Teléfono del cliente.
  final String clientPhone;

  /// Email del cliente (opcional).
  final String? clientEmail;

  /// Dirección del cliente (opcional).
  final String? clientAddress;

  /// Problema reportado por el cliente.
  final String reportedIssue;

  /// Diagnóstico técnico del problema (opcional).
  final String? diagnosis;

  /// Solución aplicada (opcional).
  final String? solution;

  /// Notas del técnico (opcional).
  final String? technicianNotes;

  /// ID del técnico asignado (opcional).
  final String? assignedTechnicianId;

  /// Nombre del técnico asignado (opcional).
  final String? assignedTechnicianName;

  /// Fecha programada para el servicio (opcional).
  final Timestamp? scheduledDate;

  /// Fecha de finalización del servicio (opcional).
  final Timestamp? completedDate;

  /// Observaciones o notas adicionales sobre el servicio.
  final String? observations;

  /// Estado del servicio técnico (ej. pending, active, completed).
  @override
  final EntityStatus status;

  /// Fecha y hora de creación del servicio.
  @override
  final Timestamp? createdAt;

  /// Fecha y hora de la última actualización del servicio.
  @override
  final Timestamp? updatedAt;

  /// Un servicio técnico vacío que representa un servicio no existente o placeholder.
  static const TechnicalServiceModel empty = TechnicalServiceModel(
    id: '',
    serviceNumber: '',
    clientName: '',
    clientPhone: '',
    reportedIssue: '',
  );

  /// Retorna `true` si el servicio es el servicio vacío.
  bool get isEmpty => this == empty;

  /// Retorna `true` si el servicio no es el servicio vacío.
  bool get isNotEmpty => this != empty;

  /// Convierte la instancia de [TechnicalServiceModel] a un mapa JSON.
  /// El `id` no se incluye porque es el ID del documento en Firestore.
  Map<String, dynamic> toJson() {
    return {
      serviceNumberKey: serviceNumber,
      clientNameKey: clientName,
      clientPhoneKey: clientPhone,
      clientEmailKey: clientEmail,
      clientAddressKey: clientAddress,
      reportedIssueKey: reportedIssue,
      diagnosisKey: diagnosis,
      solutionKey: solution,
      technicianNotesKey: technicianNotes,
      assignedTechnicianIdKey: assignedTechnicianId,
      assignedTechnicianNameKey: assignedTechnicianName,
      scheduledDateKey: scheduledDate,
      completedDateKey: completedDate,
      observationsKey: observations,
      ...metadataToJson(), // Añade los campos del mixin
    };
  }

  @override
  List<Object?> get props => [
        id,
        serviceNumber,
        clientName,
        clientPhone,
        clientEmail,
        clientAddress,
        reportedIssue,
        diagnosis,
        solution,
        technicianNotes,
        assignedTechnicianId,
        assignedTechnicianName,
        scheduledDate,
        completedDate,
        observations,
        status,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;

  TechnicalServiceModel copyWith({
    String? id,
    String? serviceNumber,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? clientAddress,
    String? reportedIssue,
    String? diagnosis,
    String? solution,
    String? technicianNotes,
    String? assignedTechnicianId,
    String? assignedTechnicianName,
    Timestamp? scheduledDate,
    Timestamp? completedDate,
    String? observations,
    EntityStatus? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TechnicalServiceModel(
      id: id ?? this.id,
      serviceNumber: serviceNumber ?? this.serviceNumber,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      clientAddress: clientAddress ?? this.clientAddress,
      reportedIssue: reportedIssue ?? this.reportedIssue,
      diagnosis: diagnosis ?? this.diagnosis,
      solution: solution ?? this.solution,
      technicianNotes: technicianNotes ?? this.technicianNotes,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      assignedTechnicianName:
          assignedTechnicianName ?? this.assignedTechnicianName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
      observations: observations ?? this.observations,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
