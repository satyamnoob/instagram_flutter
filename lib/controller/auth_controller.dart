import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/controller/storage_controller.dart';
import 'package:instagram_flutter/models/user.dart' as model;

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnapshot(documentSnapshot);
  }

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
          // ignore: unnecessary_null_comparison
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

        model.User user = model.User(
          email: email,
          uid: userCredential.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());

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

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "Please create an account first";
      } else {
        res = e.toString();
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> signout() async {
    _auth.signOut();
  }
}
