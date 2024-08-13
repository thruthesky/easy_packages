import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class CommentService {
  static CommentService? _instance;
  static CommentService get instance => _instance ??= CommentService._();

  CommentService._();

  bool initialized = false;
  CollectionReference get col =>
      FirebaseFirestore.instance.collection('comments');

  /// Callback on comment create, use this if you want to do task after comment is created., eg. push notification
  /// Callback will have the [DocumentReference] of the newly created `comment`, can be use to retrieve comment information.
  Function(DocumentReference)? onCommentCreate;

  init({
    Function(DocumentReference)? onCommentCreate,
  }) {
    if (initialized) return;
    initialized = true;
    this.onCommentCreate = onCommentCreate;
  }

  /// Returns true if comment is created or updated.
  Future<bool?> showCommentEditDialog({
    required BuildContext context,
    DocumentReference? documentReference,
    Comment? parent,
    Comment? comment,
    bool? showUploadDialog,
    bool? focusOnContent,
  }) async {
    /// 로그인 확인
    if (i.registered == false) {
      throw 'comment-edit/login-required You must be logged in to comment.';
    }

    ///
    if (context.mounted) {
      return showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true, // 중요: 이것이 있어야 키보드가 bottom sheet 을 위로 밀어 올린다.
        builder: (_) => CommentEditDialog(
          documentReference: documentReference,
          parent: parent,
          comment: comment,
          showUploadDialog: showUploadDialog,
          focusOnContent: focusOnContent,
        ),
      );
    }
    return null;
  }

  /// Get all the comments of a post
  ///
  ///
  Future<List<Comment>> getAll({
    required DocumentReference documentReference,
  }) async {
    final snapshot = await Comment.col
        .where('documentReference', isEqualTo: documentReference)
        .orderBy('order')
        .get();

    return fromQuerySnapshot(snapshot);
  }

  /// Get comments from the query snapshot.
  ///
  /// Use this method to get comments of a documentReference.
  ///
  /// This method gets the comments from the query snapshot and adds
  /// the [hasChild] property to the comment.
  ///
  fromQuerySnapshot(QuerySnapshot snapshot) {
    final comments = <Comment>[];

    if (snapshot.docs.isEmpty) {
      return comments;
    }

    /// Loop all the comments and add them as Comment object to the list.
    for (final doc in snapshot.docs) {
      final comment = Comment.fromSnapshot(doc);

      /// Find parent of current comment.
      /// This comment has parent. Attach it under the parent and update the depth.
      /// Note, there is always a parent comment for a reply. the [parentIndex] will not become -1.
      final parentIndex = comments.indexWhere(
        (e) => e.id == comment.parentId,
      );
      if (parentIndex != -1) {
        comments[parentIndex].hasChild = true;
      }
      comments.add(comment);
    }

    return comments;
  }

  /// Get the parents of the comment.
  ///
  /// It returns the list of parents in the path to the root from the comment.
  /// Use this method to get
  ///   - the parents of the comment. (This case is used by sorting comments and drawing the comment tree)
  ///   - the users(user uid) in the path to the root. Especially to know who wrote the comment in the path to the post
  List<Comment> getParents(Comment comment, List<Comment> comments) {
    final List<Comment> parents = [];
    Comment? parent = comment;
    while (parent != null) {
      parent = comments.firstWhereOrNull(
        (e) => e.id == parent!.parentId,
      );
      if (parent != null) {
        parents.add(parent);
      }
    }
    return parents.reversed.toList();
  }

  /// Return an array of user uid of the ancestors of the comment id.
  /// [commentId] comment id to get the ancestor's uid
  /// Returns the  [uids] List<String> of ancestors author uid
  Future<List<String>> getAncestorsUid(String commentId) async {
    Comment? comment = await Comment.get(commentId);

    List<String> uids = [];
    while (comment != null &&
        comment.parentId != null &&
        comment.parentId != comment.documentReference.id) {
      if (comment.parentId!.isEmpty) break;
      comment = await Comment.get(comment.parentId!);
      if (comment == null) break;
      uids.add(comment.uid);
    }
    return uids.toSet().where((uid) => uid != myUid).toList();
  }
}
