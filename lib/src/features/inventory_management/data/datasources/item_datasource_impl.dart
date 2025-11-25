import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/inventory_management/data/datasources/item_datasource.dart';
import 'package:bandasybandas/src/features/inventory_management/domain/models/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [ItemDatasource] que utiliza Firestore como backend.
class ItemDatasourceImpl implements ItemDatasource {
  ItemDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _collectionPath = DbCollections.items;

  // Referencia a la colección 'items' en Firestore.
  // Se recomienda usar un nombre de colección en plural y minúsculas.
  late final _itemsCollection =
      _firestore.collection(_collectionPath).withConverter<ItemModel>(
            fromFirestore: (snapshot, _) => ItemModel.fromFirestore(snapshot),
            toFirestore: (item, _) => item.toJson(),
          );

  @override
  Stream<List<ItemModel>> getItems() {
    // Escucha los cambios en la colección de items y los mapea a una lista de ItemModel.
    return _itemsCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  @override
  Future<void> addItem(ItemModel item) {
    // Agrega un nuevo documento a la colección 'items'.
    return _itemsCollection.add(item);
  }

  @override
  Future<void> updateItem(ItemModel item) {
    // Actualiza un documento existente en la colección 'items'.
    return _itemsCollection.doc(item.id).set(item);
  }
}
