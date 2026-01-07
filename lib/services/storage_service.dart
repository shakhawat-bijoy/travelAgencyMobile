import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image to Firebase Storage
  // Returns the download URL
  Future<String> uploadProfileImage(String userId, Uint8List imageBytes, String extension) async {
    try {
      final ref = _storage.ref().child('user_profile_images/$userId/profile.$extension');
      
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/$extension'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw 'Error uploading image: $e';
    }
  }
}
