import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/technical_service/data/datasources/technical_service_datasource.dart';
import 'package:bandasybandas/src/features/technical_service/domain/models/technical_service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [TechnicalServiceDatasource] que utiliza Firestore como backend.
class TechnicalServiceDatasourceImpl implements TechnicalServiceDatasource {
  TechnicalServiceDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _collectionPath = DbCollections.technicalServices;

  // Referencia a la colección 'technicalServices' en Firestore.
  // Se recomienda usar un nombre de colección en plural y camelCase.
  late final _technicalServicesCollection = _firestore
      .collection(_collectionPath)
      .withConverter<TechnicalServiceModel>(
        fromFirestore: (snapshot, _) =>
            TechnicalServiceModel.fromFirestore(snapshot),
        toFirestore: (service, _) => service.toJson(),
      );

  @override
  Stream<List<TechnicalServiceModel>> getTechnicalServices() {
    // Escucha los cambios en la colección de servicios técnicos y los mapea a una lista de TechnicalServiceModel.
    return _technicalServicesCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  @override
  Future<void> addTechnicalService(TechnicalServiceModel service) {
    // Agrega un nuevo documento a la colección 'technicalServices'.
    return _technicalServicesCollection.add(service);
  }

  @override
  Future<void> updateTechnicalService(TechnicalServiceModel service) {
    // Actualiza un documento existente en la colección 'technicalServices'.
    return _technicalServicesCollection.doc(service.id).set(service);
  }
}
