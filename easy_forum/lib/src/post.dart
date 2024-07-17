import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_forum/easy_forum.dart';
import 'package:easyuser/easyuser.dart';

///  Crud
/// create
/// read
/// update
/// delete
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
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'uid': uid,
        'createdAt': createdAt,
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
    final documentSnapshot = await col.doc(id).get();
    if (documentSnapshot.exists == false) {
      throw Exception('Post.get: Post not found');
    }

    return Post.fromSnapshot(documentSnapshot);
  }

  // create a new post
  // 1 doc read
  // 1 doc write
  static Future<Post?> create({
    required String title,
    required String content,
  }) async {
    if (iam.user == null) {
      throw Exception('Post.create: You must login firt to create a post');
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
    return get(id);
  }

  Future<Post?> update({
    String? title,
    String? content,
  }) async {
    final data = {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
    };
    if (data.isEmpty) {
      throw Exception('Post.update: No data to update');
    }
    await col.doc(id).update(data);

    return get(id);
  }
}
