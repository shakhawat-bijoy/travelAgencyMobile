import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage
  // Returns the download URL
  Future<String> uploadProfileImage(String userId, Uint8List imageBytes, String extension) async {
    try {
      final ref = _storage.ref().child('users/$userId/profile.$extension');
      
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/$extension'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading profile image: $e';
    }
  }

  Future<String> uploadCoverImage(String userId, Uint8List imageBytes, String extension) async {
    try {
      final ref = _storage.ref().child('users/$userId/cover.$extension');
      
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/$extension'),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading cover image: $e';
    }
  }
}
