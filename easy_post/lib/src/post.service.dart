import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_category/easy_category.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/screens/post.list.screen.dart';
import 'package:flutter/material.dart';

/// PostService is a service class that provides a set of methods to interact with the post collection in Firestore.
class PostService {
  static PostService? _instance;

  static PostService get instance => _instance ??= PostService._();
  PostService._();

  bool initialized = false;
  CollectionReference get col => FirebaseFirestore.instance.collection('posts');

  Future Function(BuildContext, Post)? $showPostDetailScreen;

  init({
    Future Function(BuildContext, Post)? showPostDetailScreen,
  }) {
    initialized = true;
    $showPostDetailScreen = showPostDetailScreen;

    addPostTranslations();
  }

  @Deprecated('Use showPostCreateScreen or showPostUpdateScreen instead')
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

  /// Show a screen to create a new post.
  Future<DocumentReference?> showPostCreateScreen({
    required BuildContext context,
    String? category,
    bool enableYoutubeUrl = false,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return PostEditScreen(
          category: category,
          enableYoutubeUrl: enableYoutubeUrl,
        );
      },
    );
  }

  ///
  Future<DocumentReference?> showPostUpdateScreen({
    required BuildContext context,
    required Post post,
    bool enableYoutubeUrl = false,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return PostEditScreen(
          category: post.category,
          post: post,
          enableYoutubeUrl: enableYoutubeUrl,
        );
      },
    );
  }

  Future showPostListScreen({
    required BuildContext context,
    required List<Category> categories,
    Post? post,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return PostListScreen(
          categories: categories,
        );
      },
    );
  }

  Future showPostDetailScreen({
    required BuildContext context,
    required Post post,
  }) {
    return $showPostDetailScreen?.call(context, post) ??
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) {
            return PostDetailScreen(post: post);
          },
        );
  }

  /// Show a screen to list youtube videos.
  Future showYoutubeListScreen({
    required BuildContext context,
    required String category,
  }) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return YoutubeListScreen(
            category: category,
          );
        });
  }

  // like
}
