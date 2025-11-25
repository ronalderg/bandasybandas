import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:bandasybandas/src/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

/// Implementación del [AuthenticationRepository] que usa Firebase Auth.
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  static const _usersCollection = 'users';

  @override
  Stream<AppUser> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      try {
        if (firebaseUser == null) {
          // Si no hay usuario de Firebase, emitimos nuestro usuario vacío.
          return AppUser.empty;
        }

        // Si hay usuario, buscamos su documento en Firestore usando su UID.
        final userDoc = await _firestore
            .collection(_usersCollection)
            .where(AppUser.keyEmail, isEqualTo: firebaseUser.email)
            .get();

        if (userDoc.docs.isNotEmpty && userDoc.docs.first.exists) {
          // Si el documento existe, creamos el modelo User a partir de él.
          return AppUser.fromFirestore(userDoc.docs.first);
        } else {
          // Si no existe (ej. primer login), creamos un User con los datos
          // básicos de Firebase Auth. Podrías querer crear el documento aquí.
          return AppUser.fromFirebaseAuth(firebaseUser);
        }
      } catch (e, s) {
        // ignore: avoid_catches_without_on_clauses
        // Si ocurre un error (ej. sin red), lo registramos y devolvemos
        // un usuario vacío para mantener la app en un estado estable.
        debugPrint('Error fetching user data from Firestore: $e');
        debugPrint(s.toString());
        return AppUser.empty;
      }
    });
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      // ignore: avoid_catches_without_on_clauses
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      // ignore: avoid_catches_without_on_clauses
      throw LogOutFailure();
    }
  }
}
