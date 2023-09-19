import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/views/add_post_view.dart';
import 'package:instagram_flutter/views/feed_view.dart';
import 'package:instagram_flutter/views/profile_view.dart';
import 'package:instagram_flutter/views/search_view.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedView(),
  SearchView(),
  Center(
    child: AddPostView(),
  ),
  Center(
    child: Text("Favorite"),
  ),
  ProfileView(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
