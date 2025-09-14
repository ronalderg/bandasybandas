// lib/src/features/authentication/data/repositories/authentication_repository_impl.dart
import 'package:bandasybandas/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Implementación del [AuthenticationRepository] que usa Firebase Auth.
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Stream<firebase_auth.User?> get user => _firebaseAuth.userChanges();

  @override
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

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
    } on Exception {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
