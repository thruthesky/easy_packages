import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easyuser/easyuser.dart';

/// Comment model
///
///
/// [id] is the unique identifier of the comment.
///
/// [parentId] is the parent comment id of current comment.
///
///
/// [documentReference] is the reference of the document of the category that this comment belongs to.
/// It is like a post reference in forum, but since the comment functionality is not limited
/// to forum, it can be any reference of any document.
///
/// [uid] is the user id of the user who posted the comment.
///
/// [content] is the content of the comment.
class Comment {
  final String id;
  final String? parentId;
  final DocumentReference documentReference;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> urls;
  final String youtubeUrl;
  final int depth;
  final String order;

  Comment({
    required this.id,
    required this.parentId,
    required this.documentReference,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.urls,
    required this.youtubeUrl,
    required this.depth,
    required this.order,
  });

  static CollectionReference get col => CommentService.instance.col;

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw 'comment-modeling/comment-not-exist Comment does not exist';
    }

    final docSnapshot = snapshot.data() as Map<String, dynamic>;
    return Comment.fromJson(docSnapshot, snapshot.id);
  }

  factory Comment.fromJson(Map<String, dynamic> json, String id) {
    return Comment(
      id: id,
      parentId: json['parentId'],
      documentReference: json['documentReference'],
      content: json['content'],
      uid: json['uid'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updateAt'] is Timestamp
          ? (json['updateAt'] as Timestamp).toDate()
          : DateTime.now(),
      urls: List<String>.from(json['urls']),
      youtubeUrl: json['youtubeUrl'],
      depth: json['depth'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'documentReference': documentReference,
      'content': content,
      'uid': uid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'urls': urls,
      'youtubeUrl': youtubeUrl,
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
  /// [documentReference] is the reference of the document that this comment belongs to.
  ///
  /// [parent] is the parent comment of the comment to be created.
  ///
  static Future<DocumentReference> create({
    required DocumentReference documentReference,
    Comment? parent,
    String? content,
  }) async {
    final snapshot = await documentReference.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final order = getCommentOrderString(
      depth: (parent?.depth ?? 0),
      noOfComments: data['commentCount'] ?? 0,
      sortString: parent?.order,
    );

    final db = FirebaseFirestore.instance;

    /// [t] 는 transaction 용 DB instance 인데, FirebaseFirestore.instance 와는 다르다.
    /// t.get() 은 Future 를 리턴하지만, t.set(), t.update() 는 Future 륄 리턴하지 않는다.
    /// t.add() 함수는 없어서, document id 를 먼저 가져와서 t.set() 으로 추가해야 한다.
    ///
    /// 아래의 코드는 코멘트를 생성 할 때, 여러개의 문서를 동시에 추가/수정 하는 것으로
    /// security rules 나 기타에 의해서 하나라도 에러가 나면, 모두 롤백된다.
    DocumentReference ref = await db.runTransaction((t) async {
      final addedRef = col.doc();
      t.set(addedRef, {
        'documentReference': documentReference,
        'parentId': parent?.id ?? '',
        'content': content,
        'uid': my.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updateAt': FieldValue.serverTimestamp(),
        'urls': [],
        'youtubeUrl': '',
        'depth': parent == null ? 1 : parent.depth + 1,
        'order': order,
      });
      t.update(documentReference, {
        'commentCount': FieldValue.increment(1),
      });
      return addedRef;
    });

    return ref;
  }
}