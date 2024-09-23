import 'package:easy_comment/easy_comment.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';

/// Comment model
///
///
/// [id] is the unique identifier of the comment.
///
/// [parentId] is the parent comment id of current comment.
///
///
/// [DatabaseReference] is the reference of the document of the category that this comment belongs to.
/// It is like a post reference in forum, but since the comment functionality is not limited
/// to forum, it can be any reference of any document.
///
/// [uid] is the user id of the user who posted the comment.
///
/// [content] is the content of the comment.
///
/// [deleted] is a boolean that must exists in the database even if it's not deleted.
/// The default value must be false. See README for details
class Comment {
  final String id;
  final String? parentId;
  final DatabaseReference ref;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> urls;
  final int depth;
  final String order;
  final bool deleted;

  ///
  bool hasChild = false;

  /// Returns true if the comment belongs to the current user.
  bool get isMine => uid == my.uid;

  Comment({
    required this.id,
    required this.parentId,
    required this.ref,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.urls,
    required this.depth,
    required this.order,
    required this.deleted,
  });

  factory Comment.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw 'comment-modeling/comment-not-exist Comment does not exist';
    }

    final docSnapshot = snapshot.value as Map<String, dynamic>;
    return Comment.fromJson(docSnapshot, snapshot.key!);
  }

  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    return Comment(
      id: id,
      parentId: json['parentId'],
      ref: CommentService.instance.commentRef(id),
      content: json['content'],
      uid: json['uid'],
      createdAt: json['createdAt'] is int ? DateTime.fromMillisecondsSinceEpoch(json['createdAt']) : DateTime.now(),
      updatedAt: json['updateAt'] is int ? DateTime.fromMillisecondsSinceEpoch(json['createdAt']) : DateTime.now(),
      urls: List<String>.from(json['urls']),
      depth: json['depth'] ?? 0,
      order: json['order'],
      deleted: json['deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'DatabaseReference': DatabaseReference,
      'content': content,
      'uid': uid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'urls': urls,
      'depth': depth,
      'order': order,
    };
  }

  @override
  String toString() {
    return 'Comment(${toJson()})';
  }

  /// Create a new comment
  ///
  /// [DatabaseReference] is the reference of the parent that this comment
  /// belongs to. It can be a user, photo, chat, or whatever.
  ///
  /// [parent] is the parent comment of the comment to be created.
  ///
  static Future<DatabaseReference> create({
    required DatabaseReference parentRef,
    Comment? parent,
    String? content,
    List<String> urls = const [],
  }) async {
    final snapshot = await parentRef.get();
    if (snapshot.exists == false) {
      throw 'comment-create/document-not-exists Document does not exist';
    }
    final data = snapshot.value as Map<String, dynamic>;
    final order = getCommentOrderString(
      depth: (parent?.depth ?? 0) + 1,
      noOfComments: data['commentCount'] ?? 0,
      sortString: parent?.order,
    );

    final newData = {
      'parentReference': parentRef.path,
      'parentId': parent?.id ?? '',
      'content': content,
      'uid': my.uid,
      'createdAt': ServerValue.timestamp,
      'updateAt': ServerValue.timestamp,
      'urls': urls,
      'depth': parent == null ? 0 : parent.depth + 1,
      'order': order,
      'deleted': false,
    };

    final Map<String, Map> updates = {};

    /// Create a comment
    final newRef = CommentService.instance.commentsRef.child(parentRef.key!).push();
    updates[newRef.path] = newData;

    /// Increment the comment count of the parent
    updates[parentRef.path] = {
      'commentCount': ServerValue.increment(1),
    };

    await CommentService.instance.ref.update(updates);

    return newRef;
  }

  /// Update the comment
  Future<void> update({
    String? content,
    List<String>? urls,
  }) async {
    await ref.update({
      if (content != null) 'content': content,
      if (urls != null) 'urls': urls,
      'updateAt': ServerValue.timestamp,
    });
  }

  // get comment
  static Future<Comment?> get(String id) async {
    if (id.isEmpty) {
      throw 'comment-get/comment-id-empty Comment id is empty';
    }
    final snapshot = await CommentService.instance.commentsRef.child(id).get();
    if (snapshot.exists == false) return null;
    return Comment.fromSnapshot(snapshot);
  }

  /// Delete the comment
  ///
  /// It does not actually delete the document. But it will delete
  /// the content, urls, and etc.
  Future<void> delete() async {
    for (String url in urls) {
      await StorageService.instance.delete(url);
    }
    await ref.update({
      'deleted': true,
      'urls': [],
      'content': '',
    });
  }
}
