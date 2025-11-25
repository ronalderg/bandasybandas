import 'package:bandasybandas/src/core/error/failures.dart';
import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/repositories/item_repository.dart';
import 'package:dartz/dartz.dart';

/// Caso de uso para obtener la lista de items.
///
/// Extiende de [UseCase] y no requiere parámetros ([NoParams]).
/// Devuelve un [Stream] de `Either` para notificar cambios en tiempo real.
class GetItems extends UseCase<Stream<List<ItemModel>>, NoParams> {
  GetItems(this.repository);
  final ItemRepository repository;

  @override
  Future<Either<Failure, Stream<List<ItemModel>>>> call(
    NoParams params,
  ) async {
    // El repositorio devuelve un Stream<Either<...>>, lo transformamos
    // para que el caso de uso devuelva un Either<Failure, Stream<...>>
    return Right(
      repository.getItems().map(
            (either) => either.fold((failure) => [], (items) => items),
          ),
    );
  }
}

/// Caso de uso para agregar un nuevo item.
///
/// Extiende de [UseCase] y requiere un [ItemModel] como parámetro.
class AddItem extends UseCase<void, ItemModel> {
  AddItem(this.repository);
  final ItemRepository repository;

  @override
  Future<Either<Failure, void>> call(ItemModel params) {
    return repository.addItem(params);
  }
}

/// Caso de uso para actualizar un item existente.
///
/// Extiende de [UseCase] y requiere un [ItemModel] como parámetro.
class UpdateItem extends UseCase<void, ItemModel> {
  UpdateItem(this.repository);
  final ItemRepository repository;

  @override
  Future<Either<Failure, void>> call(ItemModel params) {
    return repository.updateItem(params);
  }
}
