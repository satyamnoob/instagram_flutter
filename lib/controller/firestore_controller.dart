import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/controller/storage_controller.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required Uint8List file,
    required String description,
    required String uid,
    required String username,
    required String profileImage,
  }) async {
    String res = "Some error occured";
    try {
      String postPictureUrl = await StorageController().uploadImageToStorage(
        childName: 'posts',
        file: file,
        isPost: true,
      );

      String postId = const Uuid().v1();

      Post post = Post(
        postId: postId,
        uid: uid,
        postUrl: postPictureUrl,
        username: username,
        datePublished: DateTime.now(),
        description: description,
        profileImage: profileImage,
        likes: [],
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
