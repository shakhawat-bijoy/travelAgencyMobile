import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      throw e.message ?? 'An error occurred';
    } catch (e) {
      throw 'An error occurred';
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

      // Update display name if provided
      if (name != null && credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred';
    } catch (e) {
      throw 'An error occurred';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
