import 'package:bandasybandas/src/features/customers/data/datasources/customers_datasource.dart';
import 'package:bandasybandas/src/features/customers/domain/models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [CustomersDatasource] que utiliza Firestore como backend.
class CustomersDatasourceImpl implements CustomersDatasource {
  CustomersDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  // Referencia a la colección 'customers' en Firestore.
  // Se recomienda usar un nombre de colección en plural y minúsculas.
  late final _customersCollection = _firestore
      .collection('customers')
      .withConverter<CustomerModel>(
        fromFirestore: (snapshot, _) => CustomerModel.fromFirestore(snapshot),
        toFirestore: (customer, _) => customer.toJson(),
      );

  @override
  Stream<List<CustomerModel>> getCustomers() {
    // Escucha los cambios en la colección de customers y los mapea a una lista de CustomerModel.
    return _customersCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  @override
  Future<void> addCustomer(CustomerModel customer) {
    // Agrega un nuevo documento a la colección 'items'.
    return _customersCollection.add(customer);
  }
}
