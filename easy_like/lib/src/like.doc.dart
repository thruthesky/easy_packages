import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// reason for this widget is to get if the the user like the  content or not
/// to display different ui design base on the user like or not ex: changing the icon
///

/// LikeDoc is a widget that checks if the current user has liked a post.
///
/// [documentReference] is the reference to the document that contains the likes.
///
/// [uid] is the user ID to check in the likedBy list.
///
/// [builder] is a function that takes a boolean value indicating whether the
/// user has liked the post and returns a widget.
///
/// [sync] if it is passed as true, it will rebuild the widget when the post is
/// updated. If it is false, it will use FutureBuilder to get the post only one
/// time. If it is true, it will use StreamBuilder to get the post and rebuild
/// the widget when the post is updated.

class LikeDoc extends StatelessWidget {
  const LikeDoc({
    super.key,
    required this.documentReference,
    required this.uid,
    required this.builder,
    this.sync = false,
  });

  final Widget Function(bool) builder;
  final DocumentReference documentReference;
  final String uid;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('likes')
            .doc(documentReference.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            final Map<String, dynamic>? data = snapshot.data!.data();
            final List<String> likedBy =
                List<String>.from(data?['likedBy'] ?? []);

            final bool isLiked = likedBy.contains(uid);

            return builder(isLiked);
          }

          return builder(false);
        },
      );
    }

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('likes')
          .doc(documentReference.id)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData && snapshot.data!.exists) {
          final Map<String, dynamic>? data = snapshot.data!.data();
          final List<String> likedBy =
              List<String>.from(data?['likedBy'] ?? []);

          final bool isLiked = likedBy.contains(uid);

          return builder(isLiked);
        }

        return builder(false);
      },
    );
  }
}
