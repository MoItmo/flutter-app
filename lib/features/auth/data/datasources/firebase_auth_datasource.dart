// auth_remote_data_source.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/register_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in and return the Firebase [fb.User] (or null).
  Future<fb.User?> signInWithEmail(String email, String password);

  /// Register a new user with email/password, persist user doc to Firestore,
  /// and return the created RegisterModel.
  Future<RegisterModel> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<void> signOut();

  /// Emits the current firebase user state (user or null).
  Stream<fb.User?> authStateChanges();
}

class FirebaseAuthDataSource implements AuthRemoteDataSource {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<fb.User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  @override
  Future<RegisterModel> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      // create auth user
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fb.User? fbUser = cred.user;
      if (fbUser == null) {
        throw Exception('Failed to create user');
      }

      try {
        await fbUser.updateDisplayName(fullName);
      } catch (_) {
      }

      await fbUser.reload();
      final reloaded = _auth.currentUser ?? fbUser;

      final registerModel = RegisterModel.fromFirebaseUser(reloaded);


      await _firestore.collection('users').doc(registerModel.uid).set(registerModel.toMap());

      return registerModel;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'FirebaseAuthException');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Stream<fb.User?> authStateChanges() => _auth.authStateChanges();
}
