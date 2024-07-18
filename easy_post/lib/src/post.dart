import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/defines.dart';

/// Post mostly contains a `title` and `content` there might be also a image when
/// the user post image
///
/// `id` is the postid and it also the document id of the post
///
/// `title` is the title of the post
///
/// `content` is the content of the post
///
/// `urls` is the list of post image urls
///
/// `createdAt` is the time when the post is created
///
/// `updateAt` is the time when the post is update
class Post {
  // collectionReference post's collection

  final String id;
  final String category;
  final String title;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updateAt;
  final List<String> urls;

  CollectionReference col = PostService.instance.col;

  DocumentReference doc(String id) => col.doc(id);

  /// get the first image url
  String? get imageUrl => urls.isNotEmpty ? urls.first : null;

  final Map<String, dynamic> data;
  Map<String, dynamic> get extra => data;

  Post({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updateAt,
    required this.urls,
    required this.data,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
      id: id,
      category: json['category'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      uid: json['uid'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updateAt: json['updateAt'] is Timestamp
          ? (json['updateAt'] as Timestamp).toDate()
          : DateTime.now(),
      urls: json['urls'] != null ? List<String>.from(json['urls']) : [],
      data: json,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'uid': uid,
        'createdAt': createdAt,
        'updateAt': updateAt,
        'urls': urls,
      };

  @override
  String toString() {
    return 'Post(${toJson()})';
  }

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw Exception('Post.fromSnapshot: Post does not exist');
    }

    final docSnapshot = snapshot.data() as Map<String, dynamic>;
    return Post.fromJson(docSnapshot, snapshot.id);
  }

// get a post
  static Future<Post> get(String? id) async {
    if (id == null) {
      throw Exception('Post id is null');
    }
    final documentSnapshot = await PostService.instance.col.doc(id).get();
    if (documentSnapshot.exists == false) {
      throw Exception('Post.get: Post not found');
    }

    return Post.fromSnapshot(documentSnapshot);
  }

  // create a new post
  // 1 doc read
  // 1 doc write
  static Future<DocumentReference> create({
    required String category,
    String? title,
    String? content,
    List<String>? urls,
    Map<String, dynamic>? extra,
  }) async {
    if (currentUser == null) {
      throw 'post-create/sign-in-required You must login firt to create a post';
    }
    if (category.isEmpty) {
      throw 'post-create/category-is-required Category is required';
    }

    final data = {
      'category': category,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      'uid': currentUser!.uid,
      if (urls != null) 'urls': urls,
      'createdAt': FieldValue.serverTimestamp(),
    };
    return await PostService.instance.col.add({
      ...data,
      ...?extra,
    });
  }

  Future<Post?> update({
    String? title,
    String? content,
    List<String>? urls,
    Map<String, dynamic>? extra,
  }) async {
    final data = {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (urls != null) 'urls': urls,
    };
    if (data.isEmpty) {
      throw Exception('Post.update: No data to update');
    }
    await doc(id).update(
      {
        ...data,
        'updateAt': FieldValue.serverTimestamp(),
        ...?extra,
      },
    );

    return get(id);
  }
}
