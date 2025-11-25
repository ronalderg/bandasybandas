import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:dartz/dartz.dart';

/// Interfaz abstracta para el repositorio de items.
///
/// Define las operaciones que se pueden realizar sobre los datos de los items,
/// actuando como la única puerta de entrada a la capa de datos desde el dominio.
/// La capa de dominio solo depende de esta abstracción, no de su implementación.
abstract class ItemRepository {
  /// Obtiene un stream de la lista de items.
  /// Retorna un [Stream] que emite [Either] un [Failure] o una [List<ItemModel>].
  Stream<Either<Failure, List<ItemModel>>> getItems();

  /// Agrega un nuevo item.
  Future<Either<Failure, void>> addItem(ItemModel item);

  /// Actualiza un item existente.
  Future<Either<Failure, void>> updateItem(ItemModel item);
}
