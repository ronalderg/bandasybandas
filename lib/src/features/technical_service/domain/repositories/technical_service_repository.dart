import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de servicios técnicos.
///
/// Define las operaciones que se pueden realizar sobre los datos de los servicios técnicos,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class TechnicalServiceRepository {
  /// Obtiene un stream de la lista de servicios técnicos.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<TechnicalServiceModel>].
  Stream<Either<Failure, List<TechnicalServiceModel>>> getTechnicalServices();

  /// Agrega un nuevo servicio técnico.
  Future<Either<Failure, void>> addTechnicalService(
    TechnicalServiceModel service,
  );

  /// Actualiza un servicio técnico existente.
  Future<Either<Failure, void>> updateTechnicalService(
    TechnicalServiceModel service,
  );
}
