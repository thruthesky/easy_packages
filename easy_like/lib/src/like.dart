import 'package:easy_like/easy_like.dart';
import 'package:firebase_database/firebase_database.dart';

/// Support like only. Not dislike.
/// See README.md for more information.
class Like {
  /// original document reference. It is called 'target document reference'.
  final DatabaseReference parentReference;

  /// Like document reference. The document ID is the same as the target document ID.
  DatabaseReference get likeRef => LikeService.instance.likeRef(parentReference.key!);
  DatabaseReference get ref => likeRef;

  String? id;
  List<String> likedBy = [];

  Like({
    required this.parentReference,
    this.likedBy = const [],
    this.id,
  });

  factory Like.fromSnapshot(DataSnapshot snapshot) {
    return Like.fromJson(
      snapshot.value as Map<String, dynamic>,
      snapshot.key!,
    );
  }

  factory Like.fromJson(Map<String, dynamic> json, String id) {
    return Like(
      parentReference: json['parentReference'],
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
    final currentUser = LikeService.instance.auth.currentUser;

    if (currentUser == null) {
      throw LikeException('like/sign-in-required', 'User is not signed in');
    }

    final uid = currentUser.uid;

// TODO: Implement like() method: refactoring from firestore to database
    // await FirebaseFirestore.instance.runTransaction((transaction) async {
    //   FieldValue $likedBy;

    //   List<String> likedBy = [];
    //   final snapshot = await likeRef.get();
    //   if (snapshot.exists) {
    //     final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    //     likedBy = List<String>.from(data['likedBy'] ?? []);
    //   }

    //   int $likeCount = likedBy.length;

    //   /// Check if to like or to unlike.
    //   ///
    //   /// If likedBy contains the uid, the uid liked it already. So, it should unlike it.
    //   /// If likedBy does not contain the uid, then like it.
    //   bool hasLiked = likedBy.contains(uid);

    //   /// If the user has liked it, then unlike it.
    //   if (hasLiked) {
    //     $likedBy = FieldValue.arrayRemove([uid]);
    //     $likeCount--;
    //   } else {
    //     /// If the user has not liked it, then like it.
    //     $likedBy = FieldValue.arrayUnion([uid]);
    //     $likeCount++;
    //   }

    //   ///
    //   transaction.set(
    //       parentReference,
    //       {
    //         'likeCount': $likeCount,
    //       },
    //       SetOptions(
    //         merge: true,
    //       ));

    //   transaction.set(
    //     likeRef,
    //     {
    //       'parentReference': parentReference,
    //       'likedBy': $likedBy,
    //     },
    //     SetOptions(
    //       merge: true,
    //     ),
    //   );

    //   LikeService.instance.onLiked?.call(
    //     like: Like.fromJson({
    //       'parentReference': parentReference,
    //       'likedBy': likedBy,
    //     }, likeRef.id),
    //     isLiked: !hasLiked,
    //   );
    // });
  }
}
