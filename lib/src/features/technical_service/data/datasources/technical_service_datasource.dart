import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';

/// Interfaz abstracta para la fuente de datos de los servicios técnicos.
///
/// Define los métodos que deben ser implementados por cualquier datasource
/// que gestione los servicios técnicos, como obtener, crear, actualizar o eliminar.
abstract class TechnicalServiceDatasource {
  /// Obtiene un stream de la lista de servicios técnicos desde la fuente de datos.
  Stream<List<TechnicalServiceModel>> getTechnicalServices();

  /// Agrega un nuevo servicio técnico a la fuente de datos.
  Future<void> addTechnicalService(TechnicalServiceModel service);

  /// Actualiza un servicio técnico existente en la fuente de datos.
  /// @param service El [TechnicalServiceModel] con los datos actualizados.
  Future<void> updateTechnicalService(TechnicalServiceModel service);
}
