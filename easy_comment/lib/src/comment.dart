/// I am generating a dart data model named "Comment" from the following JSON:
/// {
///  "id": "1",
/// "parentId": "1",
/// "content": "This is a comment",
/// "uid": "1",
/// "createdAt": "2021-10-10T10:10:10",
/// "updatedAt": "2021-10-10T10:10:10",
/// "category": "post",
/// "postId": "1",
/// "urls": ["https://example.com", "https://example.com"],
/// "youtubeUrl": "https://www.youtube.com/watch?v=123456",
/// }
///
library;

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String parentId;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final String postId;
  final List<String> urls;
  final String youtubeUrl;

  Comment({
    required this.id,
    required this.parentId,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.postId,
    required this.urls,
    required this.youtubeUrl,
  });

  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    return Comment(
      id: id,
      parentId: json['parentId'],
      content: json['content'],
      uid: json['uid'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updateAt: json['updateAt'] is Timestamp
          ? (json['updateAt'] as Timestamp).toDate()
          : DateTime.now(),
      category: json['category'],
      postId: json['postId'],
      urls: List<String>.from(json['urls']),
      youtubeUrl: json['youtubeUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parentId': parentId,
      'content': content,
      'uid': uid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category,
      'postId': postId,
      'urls': urls,
      'youtubeUrl': youtubeUrl,
    };
  }
}
