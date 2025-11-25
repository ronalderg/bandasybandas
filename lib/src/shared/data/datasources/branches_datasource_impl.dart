import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/shared/data/datasources/branches_datasource.dart';
import 'package:bandasybandas/src/shared/models/branch_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [BranchesDatasource] que utiliza Firestore como backend.
class BranchesDatasourceImpl implements BranchesDatasource {
  BranchesDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  // Referencia a la colección 'branches' en Firestore.
  // Se recomienda usar un nombre de colección en plural y minúsculas.
  late final _branchesCollection =
      _firestore.collection(DbCollections.branches).withConverter<BranchModel>(
            fromFirestore: (snapshot, _) => BranchModel.fromFirestore(snapshot),
            toFirestore: (branch, _) => branch.toJson(),
          );

  @override
  Stream<List<BranchModel>> getBranches() {
    // Escucha los cambios en la colección de branches y los mapea a una lista de BranchModel.
    return _branchesCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  @override
  Future<void> createBranch(BranchModel branch) {
    // Crea un nuevo documento a la colección 'branches'.
    return _branchesCollection.add(branch);
  }

  @override
  Future<void> updateBranch(BranchModel branch) {
    // Actualiza un documento existente en la colección 'branches'.
    return _branchesCollection.doc(branch.id).update(branch.toJson());
  }

  @override
  Future<void> deleteBranch(String id) {
    // Elimina un documento de la colección 'branches' por su ID.
    return _branchesCollection.doc(id).delete();
  }
}
