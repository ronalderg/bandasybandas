import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:bandasybandas/src/features/technical_service/domain/repositories/technical_service_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de servicios técnicos.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetTechnicalServices
    extends UseCase<Stream<List<TechnicalServiceModel>>, NoParams> {
  GetTechnicalServices(this.repository);
  final TechnicalServiceRepository repository;

  @override
  Future<Either<Failure, Stream<List<TechnicalServiceModel>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getTechnicalServices().map(
            (either) => either.fold((failure) => [], (services) => services),
          ),
    );
  }
}

/// Caso de uso para agregar un nuevo servicio técnico.
///
/// Extiende de [UseCase] y requiere un [TechnicalServiceModel] como parámetro.
class AddTechnicalService extends UseCase<void, TechnicalServiceModel> {
  AddTechnicalService(this.repository);
  final TechnicalServiceRepository repository;

  @override
  Future<Either<Failure, void>> call(TechnicalServiceModel params) {
    return repository.addTechnicalService(params);
  }
}

/// Caso de uso para actualizar un servicio técnico existente.
///
/// Extiende de [UseCase] y requiere un [TechnicalServiceModel] como parámetro.
class UpdateTechnicalService extends UseCase<void, TechnicalServiceModel> {
  UpdateTechnicalService(this.repository);
  final TechnicalServiceRepository repository;

  @override
  Future<Either<Failure, void>> call(TechnicalServiceModel params) {
    return repository.updateTechnicalService(params);
  }
}
