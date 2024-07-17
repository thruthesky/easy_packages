import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/screens/post.list.screen.dart';
import 'package:flutter/material.dart';

class PostService {
  static PostService? _instance;

  static PostService get instance => _instance ??= PostService._();
  PostService._();

  bool initialized = false;
  CollectionReference get col => FirebaseFirestore.instance.collection('posts');

  init() {
    initialized = true;
  }

  Future<Post?> showPostEditScreen({
    required BuildContext context,
    Post? post,
  }) {
    return showGeneralDialog<Post?>(
      context: context,
      pageBuilder: (_, __, ___) {
        return const PostEditScreen();
      },
    );
  }

  Future<Post?> showPostListScreen({
    required BuildContext context,
    Post? post,
  }) {
    return showGeneralDialog<Post?>(
      context: context,
      pageBuilder: (_, __, ___) {
        return const PostListScreen();
      },
    );
  }
}
