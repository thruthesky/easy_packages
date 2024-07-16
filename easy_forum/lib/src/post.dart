import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_forum/easy_forum.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';

class Post {
  // collectionReference post's collection
  static CollectionReference col = PostService.instance.col;

  // post id
  final String id;
  final String title;
  final String content;
  final String uid;
  final DateTime? createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.uid,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
      id: id,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      uid: json['uid'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // create a new post
  static Future create({
    required String title,
    required String content,
  }) async {
    if (iam.user == null) {
      throw ('You must login firt to create a post ');
    }
    final id = Post.col.doc().id;
    final data = {
      'id': id,
      'title': title,
      'content': content,
      'uid': iam.user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await col.doc(id).set(
          data,
          SetOptions(merge: true),
        );
  }
}
