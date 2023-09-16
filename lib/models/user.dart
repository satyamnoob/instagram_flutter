import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
      "photoUrl": photoUrl,
      "bio": bio,
      "followers": followers,
      "following": following,
    };
  }

  static User fromSnapshot(DocumentSnapshot documentSnapshot) {
    var userSnapshot = documentSnapshot.data() as Map<String, dynamic>;

    return User(
      email: userSnapshot['email'],
      uid: userSnapshot['uid'],
      photoUrl: userSnapshot['photoUrl'],
      username: userSnapshot['username'],
      bio: userSnapshot['bio'],
      followers: userSnapshot['followers'],
      following: userSnapshot['following'],
    );
  }
}
