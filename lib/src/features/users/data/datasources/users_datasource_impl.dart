import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/users/data/datasources/users_datasource.dart';
import 'package:bandasybandas/src/shared/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Implementación de [UsersDatasource] que utiliza Firestore como backend.
class UsersDatasourceImpl implements UsersDatasource {
  UsersDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  // Referencia a la colección 'Users' en Firestore.
  // Se recomienda usar un nombre de colección en plural y minúsculas.
  late final _usersCollection =
      _firestore.collection(DbCollections.users).withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromFirestore(snapshot),
            toFirestore: (user, _) => user.toJson(),
          );

  @override
  Stream<List<AppUser>> getUsers() {
    // Escucha los cambios en la colección de Users y los mapea a una lista de AppUser.
    return _usersCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  @override
  Future<void> addUser(AppUser user) {
    // Agrega un nuevo documento a la colección 'items'.
    return _usersCollection.add(user);
  }
}
