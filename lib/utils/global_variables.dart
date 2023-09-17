import 'package:flutter/material.dart';
import 'package:instagram_flutter/views/add_post_view.dart';
import 'package:instagram_flutter/views/feed_view.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedView(),
  Center(
    child: Text("Search"),
  ),
  Center(
    child: AddPostView(),
  ),
  Center(
    child: Text("Favorite"),
  ),
  Center(
    child: Text("Profile"),
  ),
];
