import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Support like only. Not dislike.
/// See README.md for more information.
class Like {
  static CollectionReference get col =>
      FirebaseFirestore.instance.collection('likes');

  /// original document reference. It is called 'target document reference'.
  final DocumentReference documentReference;
  DocumentReference get likeRef => col.doc(documentReference.id);

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
  static Future<void> like() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('User is not signed in');
    }

    final uid = currentUser.uid;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      FieldValue $likedBy;

      List<String> likedBy = [];
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;
        likedBy = List<String>.from(data['likedBy'] ?? []);
      }

      int $likeCount = likedBy.length;

      /// If liked already then, unlike it;
      if (likedBy.contains(uid)) {
        $likedBy = FieldValue.arrayRemove([uid]);
        $likeCount--;
      } else {
        $likedBy = FieldValue.arrayUnion([uid]);
        $likeCount++;
      }

      ///
      transaction.set(
          ref,
          {
            'likeCount': $likeCount,
          },
          SetOptions(
            merge: true,
          ));

      transaction.set(
          likeRef,
          {
            'likeCount': $likeCount,
            'likedBy': $likedBy,
          },
          SetOptions(
            merge: true,
          ));
    });
  }
}
