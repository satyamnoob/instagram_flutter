import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/controller/storage_controller.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/utils/utils.dart';
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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment({
    required String postId,
    required String comment,
    required String uid,
    required String username,
    required String profilePic,
    required BuildContext context,
  }) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'username': username,
          'uid': uid,
          'comment': comment,
          'commentId': commentId,
          'postId': postId,
          'datePublished': DateTime.now(),
        });
      } else {
        showSnackBar(
          content: 'comment is empty',
          context: context,
          isError: true,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          content: e.toString(),
          context: context,
          isError: true,
        );
      }
    }
    if (context.mounted) {
      showSnackBar(
        content: 'comment posted',
        context: context,
      );
    }
  }

  Future<String> deletePost({required String postId}) async {
    String res = "some error occured";

    try {
      await _firestore.collection("posts").doc(postId).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> followUser(
      {required String uid, required String followId}) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
