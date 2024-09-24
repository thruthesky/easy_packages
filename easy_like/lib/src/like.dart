import 'package:easy_like/easy_like.dart';
import 'package:firebase_database/firebase_database.dart';

/// Support like only. Not dislike.
/// See README.md for more information.
class Like {
  /// original document reference. It is called 'target document reference'.
  final DatabaseReference parentReference;

  /// Like document reference. The document ID is the same as the target document ID.
  DatabaseReference get likeRef => LikeService.instance.likeRef(parentReference.key!.replaceAll('-', '/'));
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
      parentReference: FirebaseDatabase.instance.ref(json['parentReference'].replaceAll('-', '/')),
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

    final snapshot = await likeRef.get();

    /// Read the list from database to double check if all the data is updated.
    List<String> likedBy = [];
    if (snapshot.exists) {
      likedBy = List<String>.from((snapshot.value as Map).keys);
    }

    bool hasLiked = likedBy.contains(uid);
    final updates = {
      parentReference.path.replaceAll('-', '/'): ServerValue.increment(1),
      ref.path: hasLiked ? {uid: null} : {uid: true},
    };

    await FirebaseDatabase.instance.ref().update(updates);

    LikeService.instance.onLiked?.call(
      like: Like.fromJson({
        'parentReference': parentReference,
        'likedBy': likedBy,
      }, parentReference.key!),
      isLiked: !hasLiked,
    );
  }
}
