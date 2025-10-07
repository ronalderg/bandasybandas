import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Clase base abstracta para un Caso de Uso (Use Case).
///
/// Define un contrato estandarizado para la ejecución de una lógica de negocio.
/// [Type] es el tipo de dato que se devuelve en caso de éxito.
/// [Params] es el tipo de los parámetros requeridos para ejecutar el caso de uso.
abstract class UseCase<Type, Params> {
  /// Ejecuta el caso de uso.
  Future<Either<Failure, Type>> call(Params params);
}

/// Una clase para representar la ausencia de parámetros en un caso de uso.
///
/// Se utiliza como el tipo [Params] en la clase [UseCase] cuando un caso de uso
/// no necesita ningún parámetro de entrada.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
