import 'package:bandasybandas/src/features/orders_management/data/datasorces/order_requests_datasource.dart';
import 'package:bandasybandas/src/features/orders_management/domain/models/order_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [OrderRequestsDatasource] que utiliza Firestore como backend.
class OrderRequestsDatasourceImpl implements OrderRequestsDatasource {
  OrderRequestsDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  // Referencia a la colección 'orders_requests' en Firestore.
  // Se recomienda usar un nombre de colección en plural y minúsculas.
  late final _ordersRequestsCollection =
      _firestore.collection('orders_requests').withConverter<OrderRequestModel>(
            fromFirestore: (snapshot, _) =>
                OrderRequestModel.fromFirestore(snapshot),
            toFirestore: (orderRequest, _) => orderRequest.toJson(),
          );

  @override
  Stream<List<OrderRequestModel>> getOrdersRequests() {
    // Escucha los cambios en la colección de orders_requests y los mapea a una lista de OrderRequestModel.
    return _ordersRequestsCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  @override
  Future<void> createOrderRequest(OrderRequestModel orderRequest) {
    // Agrega un nuevo documento a la colección 'orders_requests'.
    return _ordersRequestsCollection.add(orderRequest);
  }

  @override
  Future<void> updateOrderRequest(OrderRequestModel orderRequest) {
    // Actualiza un documento existente en la colección 'orders_requests'.
    return _ordersRequestsCollection
        .doc(orderRequest.id)
        .update(orderRequest.toJson());
  }

  @override
  Future<void> deleteOrderRequest(String id) {
    // Elimina un documento de la colección 'orders_requests'.
    return _ordersRequestsCollection.doc(id).delete();
  }
}
