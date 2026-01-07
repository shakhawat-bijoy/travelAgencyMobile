import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import './firestore_service.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Stream of auth changes
  Stream<User?> get user => _auth.authStateChanges();

  // Sign in with persistence option
  Future<UserCredential?> signIn(
    String email,
    String password, {
    bool keepSignedIn = true,
  }) async {
    try {
      // Set persistence based on user preference
      // Persistence is only supported on Web. Guard to avoid runtime errors.
      if (kIsWeb) {
        if (keepSignedIn) {
          await _auth.setPersistence(Persistence.LOCAL);
        } else {
          await _auth.setPersistence(Persistence.SESSION);
        }
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('FIREBASE AUTH ERROR: ${e.code} - ${e.message}');
      throw e.message ?? 'An error occurred';
    } catch (e) {
      if (kDebugMode) print('SIGN IN ERROR: $e');
      throw e.toString();
    }
  }

  // Sign up
  Future<UserCredential?> signUp(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user model and save to Firestore
      if (credential.user != null) {
        UserModel newUser = UserModel(
          uid: credential.user!.uid,
          email: email,
          displayName: name ?? email.split('@')[0],
        );
        
        try {
          await _firestoreService.saveUserData(newUser);
        } catch (e) {
          if (kDebugMode) {
            print('FIRESTORE SAVE ERROR during registration: $e');
            print('CHECK SYSTEM: Ensure Cloud Firestore is enabled in Firebase Console and Rules allow write access to "users" collection.');
          }
          // We don't throw here so registration can still succeed if the user was created.
          // The Profile Screen can handle missing data using defaults.
        }
      }

      // Update display name if provided
      if (name != null && credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('FIREBASE REGISTRATION ERROR: ${e.code} - ${e.message}');
      throw e.message ?? 'An error occurred during registration';
    } catch (e) {
      if (kDebugMode) print('GENERAL REGISTRATION ERROR: $e');
      throw e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('FIREBASE RESET ERROR: ${e.code} - ${e.message}');
      throw e.message ?? 'An error occurred during password reset';
    } catch (e) {
      if (kDebugMode) print('GENERAL RESET ERROR: $e');
      throw e.toString();
    }
  }
}
