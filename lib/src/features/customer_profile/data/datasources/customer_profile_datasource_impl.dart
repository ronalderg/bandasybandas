import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/customer_profile/data/datasources/customer_profile_datasource.dart';

import 'package:bandasybandas/src/features/customer_profile/domain/models/customer_product_model.dart';
import 'package:bandasybandas/src/shared/models/entity_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [CustomerProfileDatasource] que utiliza Firestore.
class CustomerProfileDatasourceImpl implements CustomerProfileDatasource {
  CustomerProfileDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _customerProductsCollection =>
      _firestore.collection(DbCollections.customerProducts);

  @override
  Stream<List<CustomerProductModel>> getCustomerProducts(String customerId) {
    // Escucha los cambios en la colección de productos del cliente,
    // filtrando por customerId y excluyendo los marcados como 'deleted'.
    return _customerProductsCollection
        .where(CustomerProductModel.keyCustomerId, isEqualTo: customerId)
        .where(
          EntityMetadata.statusKey,
          isNotEqualTo: EntityStatus.deleted.name,
        )
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(CustomerProductModel.fromFirestore).toList(),
        );
  }

  @override
  Future<void> addCustomerProduct(CustomerProductModel product) async {
    await _customerProductsCollection.add(product.toJson());
  }

  @override
  Future<void> updateCustomerProduct(CustomerProductModel product) async {
    await _customerProductsCollection.doc(product.id).update(
          product.toJson(),
        );
  }
}
