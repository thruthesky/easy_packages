import 'package:cloud_firestore/cloud_firestore.dart';

/// Support like only. Not dislike.
/// See README.md for more information.
class Like {
  /// uid should be the login user's uid (or it can be any user id)
  ///
  /// It does not fix the user's uid as FirebaseAuth.instance.currentUser.uid
  /// So, it can be any user's uid. But generally, it should be the login
  /// user's uid.
  ///
  /// To force to it to be the login user's uid, you can use Firestore security rules
  final String uid;

  /// original document reference
  final DocumentReference documentReference;
  DocumentReference get ref =>
      FirebaseFirestore.instance.collection('likes').doc(documentReference.id);

  Like({
    required this.uid,
    required this.documentReference,
  });

  /// When the user likes the document,
  ///
  /// - Add the user's uid to the likedBy list
  /// - Increase the likes count
  /// - Increaes the likes count in the document
  Future<void> like() async {
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
          documentReference,
          {
            'likeCount': $likeCount,
          },
          SetOptions(
            merge: true,
          ));

      transaction.set(
          ref,
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
