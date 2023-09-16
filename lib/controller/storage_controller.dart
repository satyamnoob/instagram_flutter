import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to Firebase Storage
  Future<String> uploadImageToStorage({
    required String childName,
    required Uint8List file,
    bool isPost = false,
  }) async {
    Reference reference =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    UploadTask uploadTask = reference.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
