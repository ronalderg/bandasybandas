import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';

/// Interfaz abstracta para la fuente de datos de los items.
///
/// Define los métodos que deben ser implementados por cualquier datasource
/// que gestione los items, como obtener, crear, actualizar o eliminar.
abstract class ItemDatasource {
  /// Obtiene un stream de la lista de items desde la fuente de datos.
  Stream<List<ItemModel>> getItems();

  /// Agrega un nuevo item a la fuente de datos.
  Future<void> addItem(ItemModel item);

  /// Actualiza un item existente en la fuente de datos.
  /// @param item El [ItemModel] con los datos actualizados.
  Future<void> updateItem(ItemModel item);
}
