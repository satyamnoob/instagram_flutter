import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/controller/storage_controller.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        // register user
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential.user!.uid);

        String photoUrl = await StorageController().uploadImageToStorage(
          childName: 'profilePics',
          file: file,
          isPost: false,
        );

        // add user to our database
        //set
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': username,
          'uid': userCredential.user!.uid,
          'bio': bio,
          'email': email,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email is invalid';
      } else if (e.code == 'weak-password') {
        res = 'The password you entered is weak';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
