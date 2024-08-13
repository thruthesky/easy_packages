import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_like/easy_like.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// LikeDoc builds (or rebuilds) widget based on the like status of the user.
///
/// if the current user has liked the document, it will build the widget with
/// true. Otherwise, it will build the widget with false.
///
/// [documentReference] is the reference to the document that contains the likes.
///
/// [builder] is a function that takes a boolean value indicating whether the
/// user has liked the post and returns a widget.
///
/// [sync] if it is passed as true, it will rebuild the widget when the post is
/// updated. If it is false, it will use FutureBuilder to get the post only one
/// time. If it is true, it will use StreamBuilder to get the post and rebuild
/// the widget when the post is updated.
///
/// To use this widget, the user needs to be login first. Or this widget always
/// build with false.

class LikeDoc extends StatelessWidget {
  const LikeDoc({
    super.key,
    required this.documentReference,
    required this.builder,
    this.initialData,
    this.sync = false,
  });

  final Widget Function(bool) builder;
  final DocumentReference documentReference;
  final bool sync;
  final bool? initialData;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (sync) {
      return StreamBuilder<bool?>(
        initialData: initialData,
        stream: Like.col.doc(documentReference.id).snapshots().map((snapshot) {
          if (snapshot.exists == false) return null;
          final like = Like.fromSnapshot(snapshot);
          return like.likedBy.contains(uid);
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData == false) {
            return const SizedBox.shrink();
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return builder(snapshot.data ?? false);
        },
      );
    }

    return FutureBuilder<bool?>(
      initialData: initialData,
      future: Like.col.doc(documentReference.id).get().then((snapshot) {
        if (snapshot.exists == false) return null;
        final like = Like.fromSnapshot(snapshot);
        return like.likedBy.contains(uid);
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return builder(snapshot.data ?? false);
      },
    );
  }
}
