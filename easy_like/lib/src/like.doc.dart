import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_like/easy_like.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// LikeDoc builds (or rebuilds) widget based on the like status of the user.
/// If the current user has liked the document, it will build the widget with
/// true. Otherwise, it will build the widget with false.
///
/// [documentReference] is the reference to the document that contains the likes.
/// [builder] is a function that takes a boolean value indicating whether the
/// user has liked the post and returns a widget.
/// [sync] controls whether the widget updates with real-time changes (using
/// StreamBuilder) or loads the state once (using FutureBuilder).
///
/// To use this widget, the user needs to be logged in. If not, the widget will
/// build with false.

class LikeDoc extends StatefulWidget {
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
  State<LikeDoc> createState() => _LikeDocState();
}

class _LikeDocState extends State<LikeDoc> {
  bool? isLike;

  @override
  void initState() {
    super.initState();
    isLike = widget.initialData;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (widget.sync) {
      return StreamBuilder<bool?>(
        initialData: isLike,
        stream: Like.col
            .doc(widget.documentReference.id)
            .snapshots()
            .map((snapshot) {
          if (!snapshot.exists) return null;
          final like = Like.fromSnapshot(snapshot);
          return like.likedBy.contains(uid);
        }),
        builder: (context, snapshot) {
          // Keep the current value to avoid flickering during waiting state.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return widget.builder(isLike ?? false);
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }

          // Update the like status based on the snapshot data.
          isLike = snapshot.data ?? false;
          return widget.builder(isLike!);
        },
      );
    }

    return FutureBuilder<bool?>(
      initialData: isLike,
      future: Like.col.doc(widget.documentReference.id).get().then((snapshot) {
        if (!snapshot.exists) return null;
        final like = Like.fromSnapshot(snapshot);
        return like.likedBy.contains(uid);
      }),
      builder: (context, snapshot) {
        // Maintain state during loading to reduce flickering.
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return widget.builder(isLike ?? false);
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error.toString()}');
        }
        isLike = snapshot.data ?? false;
        return widget.builder(isLike!);
      },
    );
  }
}
