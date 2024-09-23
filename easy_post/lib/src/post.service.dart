import 'package:easy_category/easy_category.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/screens/post.list.screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// PostService is a service class that provides a set of methods to interact with the post collection in Firestore.
class PostService {
  static PostService? _instance;

  static PostService get instance => _instance ??= PostService._();
  PostService._();

  bool initialized = false;

  FirebaseDatabase get database => FirebaseDatabase.instance;

  DatabaseReference get postsRef => database.ref().child('posts');

  Future Function(BuildContext, Post)? $showPostDetailScreen;
  Future<DatabaseReference?> Function(BuildContext, String?)? $showPostCreateScreen;
  Future<DatabaseReference?> Function(BuildContext, Post)? $showPostUpdateScreen;

  String? youtubeDataApi;

  /// Callback on post create, use this if you want to do task after post is created.,
  /// Usage: e.g. send push notification to category subscribers after post is created.
  /// Callback will have the [Post] of the newly created `post` information.
  Function(Post)? onCreate;

  /// Add custom widget on chatroom header,.
  /// e.g. push notification toggle button
  /// [category] the current category selected, can be null if no category is selected.
  Widget Function(String? category)? postListActionButton;

  init({
    Future Function(BuildContext, Post)? showPostDetailScreen,
    Future<DatabaseReference?> Function(BuildContext, String?)? showPostCreateScreen,
    Future<DatabaseReference?> Function(BuildContext, Post)? showPostUpdateScreen,
    String? youtubeDataApi,
    Function(Post)? onCreate,
    Widget Function(String? category)? postListActionButton,
  }) {
    if (initialized) {
      return;
    }

    initialized = true;
    $showPostDetailScreen = showPostDetailScreen;
    $showPostCreateScreen = showPostCreateScreen;
    $showPostUpdateScreen = showPostUpdateScreen;
    this.youtubeDataApi = youtubeDataApi;
    this.onCreate = onCreate;
    this.postListActionButton = postListActionButton;
    addPostTranslations();
  }

  @Deprecated('Use showPostCreateScreen or showPostUpdateScreen instead')
  Future<DatabaseReference?> showPostEditScreen({
    required BuildContext context,
    required String? category,
    Post? post,
  }) {
    return showGeneralDialog<DatabaseReference?>(
      context: context,
      pageBuilder: (_, __, ___) {
        return PostEditScreen(category: category);
      },
    );
  }

  /// Show a screen to create a new post.
  Future<DatabaseReference?> showPostCreateScreen({
    required BuildContext context,
    String? category,
    bool enableYoutubeUrl = false,
  }) {
    return $showPostCreateScreen?.call(context, category) ??
        showGeneralDialog(
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
  Future<DatabaseReference?> showPostUpdateScreen({
    required BuildContext context,
    required Post post,
    bool enableYoutubeUrl = false,
  }) {
    return $showPostUpdateScreen?.call(context, post) ??
        showGeneralDialog(
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

  /// Get the last n posts of the category from the Database.
  Future<List<Post>> getPosts({
    required String category,
    Query? query,
    // String? uid,
    String? orderBy,
    int limit = 10,
  }) async {
    if (query != null) {
      return await getPostsFromQuery(query);
    }
    Query q = postsRef.child(category);
    q = q.orderByChild(Post.field.order);
    q = q.limitToFirst(limit);
    return await getPostsFromQuery(q);
  }

  /// Get posts from snapshot
  List<Post> getPostsFromSnapshot(DataSnapshot snapshot) {
    return snapshot.children.map((doc) => Post.fromSnapshot(doc)).toList();
  }

  /// Get posts from Query
  Future<List<Post>> getPostsFromQuery(Query query) async {
    final snapshot = await query.get();
    return getPostsFromSnapshot(snapshot);
  }
}
