import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/screens/post.detail.screen.dart';
import 'package:easy_post_v2/src/screens/post.list.screen.dart';
import 'package:flutter/material.dart';

class PostService {
  static PostService? _instance;

  static PostService get instance => _instance ??= PostService._();
  PostService._();

  bool initialized = false;
  CollectionReference get col => FirebaseFirestore.instance.collection('posts');

  late Map<String, String> categories = {
    'qna': 'QnA',
    'discussion': 'Discussion',
    'news': 'News',
  };

  init({Map<String, String>? categories}) {
    initialized = true;
    this.categories = categories ?? this.categories;
  }

  Future<DocumentReference?> showPostEditScreen({
    required BuildContext context,
    required String? category,
    Post? post,
  }) {
    return showGeneralDialog<DocumentReference?>(
      context: context,
      pageBuilder: (_, __, ___) {
        return PostEditScreen(category: category);
      },
    );
  }

  Future showPostListScreen({
    required BuildContext context,
    Post? post,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return const PostListScreen();
      },
    );
  }

  Future showPostDetailScreen({
    required BuildContext context,
    required Post post,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return PostDetailScreen(post: post);
      },
    );
  }

  Future showYoutubeScreen({
    required BuildContext context,
    required Post post,
    bool autoPlay = false
  }) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return YoutubeScreen(post: post, autoPlay: autoPlay);
        });
  }
}
