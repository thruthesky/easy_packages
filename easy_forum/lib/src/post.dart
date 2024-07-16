import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String uid;
  final DateTime createdAt;

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
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
