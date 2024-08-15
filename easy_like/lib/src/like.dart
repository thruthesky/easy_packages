import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_like/easy_like.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Support like only. Not dislike.
/// See README.md for more information.
class Like {
  static CollectionReference get col =>
      FirebaseFirestore.instance.collection('likes');

  /// original document reference. It is called 'target document reference'.
  final DocumentReference documentReference;

  /// Like document reference. The document ID is the same as the target document ID.
  DocumentReference get likeRef => col.doc(documentReference.id);
  DocumentReference get ref => likeRef;

  String? id;
  List<String> likedBy = [];

  Like({
    required this.documentReference,
    this.likedBy = const [],
    this.id,
  });

  factory Like.fromSnapshot(DocumentSnapshot snapshot) {
    return Like.fromJson(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }

  factory Like.fromJson(Map<String, dynamic> json, String id) {
    return Like(
      documentReference: json['documentReference'],
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  /// Like (or dislike)
  ///
  /// [uid] is the user's uid who likes (or unlikes) the document.
  ///
  /// When the user likes the document,
  ///
  /// - Add the user's uid to the likedBy list
  /// - Increase the likes count
  /// - Increaes the likes count in the document
  Future<void> like() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw LikeException('like/sign-in-required', 'User is not signed in');
    }

    final uid = currentUser.uid;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      FieldValue $likedBy;

      List<String> likedBy = [];
      final snapshot = await likeRef.get();
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        likedBy = List<String>.from(data['likedBy'] ?? []);
      }

      int $likeCount = likedBy.length;

      /// Check if to like or to unlike.
      ///
      /// If likedBy contains the uid, the uid liked it already. So, it should unlike it.
      /// If likedBy does not contain the uid, then like it.
      bool hasLiked = likedBy.contains(uid);

      /// If the user has liked it, then unlike it.
      if (hasLiked) {
        $likedBy = FieldValue.arrayRemove([uid]);
        $likeCount--;
      } else {
        /// If the user has not liked it, then like it.
        $likedBy = FieldValue.arrayUnion([uid]);
        $likeCount++;
      }

      ///
      transaction.set(
          documentReference,
          {
            'likeCount': $likeCount,
          },
          SetOptions(
            merge: true,
          ));

      transaction.set(
        likeRef,
        {
          'documentReference': documentReference,
          'likeCount': $likeCount,
          'likedBy': $likedBy,
        },
        SetOptions(
          merge: true,
        ),
      );
      LikeService.instance.onLiked?.call(
        like: Like.fromJson({
          'documentReference': documentReference,
          'likeCount': $likeCount,
          'likedBy': likedBy,
        }, likeRef.id),
        isLiked: !hasLiked,
      );
    });
  }
}
