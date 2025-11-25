import 'package:bandasybandas/src/core/db_collections.dart';
import 'package:bandasybandas/src/features/users/data/datasources/users_datasource.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Implementación de [UsersDatasource] que utiliza Firestore como backend.
class UsersDatasourceImpl implements UsersDatasource {
  UsersDatasourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

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
  Future<void> updateUser(AppUser user) {
    // Actualiza un documento existente en la colección 'users'.
    return _usersCollection.doc(user.id).set(user);
  }

  @override
  Future<void> deleteUser(String userId) {
    // Elimina un documento existente en la colección 'users'.
    return _usersCollection.doc(userId).delete();
  }

  @override
  Future<void> addUser(AppUser user, String password) async {
    try {
      // 1. Crear el usuario en Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // 2. Obtener el UID del usuario creado
      final uid = userCredential.user!.uid;

      // 3. Guardar los datos del usuario en Firestore usando el UID como document ID
      final userWithId = user.copyWith(id: uid);
      await _usersCollection.doc(uid).set(userWithId);
    } on FirebaseAuthException catch (e) {
      // Propagar el error de Firebase Auth para que sea manejado en capas superiores
      throw Exception('Error al crear usuario en Firebase Auth: ${e.message}');
    } on FirebaseException catch (e) {
      // Propagar el error de Firestore
      throw Exception('Error al guardar usuario en Firestore: ${e.message}');
    }
  }
}
