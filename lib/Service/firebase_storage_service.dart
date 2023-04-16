import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFile(
    String filePath,
    String fileName,
    File? uploadedFile,
  ) async {
    final storageReference = _firebaseStorage.ref('trades').child(filePath);
    String? url;
    if (uploadedFile != null) {
      await storageReference.putFile(uploadedFile);
      url = await storageReference.getDownloadURL();
    }
    return url;
  }

  Future<void> deleteFile(String filePath, String fileName) async {
    final url = '$filePath/$fileName';
    final storageReference = _firebaseStorage.ref(url);
    try {
      await storageReference.delete();
    } catch (e) {
      debugPrint('file delete error:$e');
    }
  }

  Future<void> deleteFolder({required String? path}) async {
    try {
      final value = await _firebaseStorage.ref(path).listAll();
      await _firebaseStorage.ref(value.items.first.fullPath).delete();
    } catch (e) {
      debugPrint('Firebase Storage delete error: $e');
    }
  }
}
