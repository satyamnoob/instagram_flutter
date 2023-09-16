import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String uid;
  final String postUrl;
  final String username;
  final datePublished;
  final String description;
  final String profileImage;
  final likes;

  Post({
    required this.postId,
    required this.uid,
    required this.postUrl,
    required this.username,
    required this.datePublished,
    required this.description,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "postId": postId,
      "uid": uid,
      "postUrl": postUrl,
      "username": username,
      "datePublished": datePublished,
      "profileImage": profileImage,
      "likes": likes,
    };
  }

  static Post fromSnapshot(DocumentSnapshot documentSnapshot) {
    var userSnapshot = documentSnapshot.data() as Map<String, dynamic>;

    return Post(
        description: userSnapshot['description'],
        uid: userSnapshot['uid'],
        postId: userSnapshot['postId'],
        username: userSnapshot['username'],
        postUrl: userSnapshot['postUrl'],
        datePublished: userSnapshot['datePublished'],
        likes: userSnapshot['likes'],
        profileImage: userSnapshot['profileImage']);
  }
}
