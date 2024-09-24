import 'package:easy_like/easy_like.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// LikeDoc builds (or rebuilds) widget based on the like status of the user.
/// If the current user has liked the document, it will build the widget with
/// true. Otherwise, it will build the widget with false.
///
/// [parentRef] is the reference to the document that contains the likes.
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
    required this.parentRef,
    required this.builder,
    this.sync = false,
  });

  final Widget Function(bool) builder;
  final DatabaseReference parentRef;
  final bool sync;

  @override
  State<LikeDoc> createState() => _LikeDocState();
}

class _LikeDocState extends State<LikeDoc> {
  dynamic data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final id = widget.parentRef.key!.replaceAll('/', '-');

    return Value(
      ref: LikeService.instance.likesRef.child(id),
      initialData: data,
      sync: widget.sync,
      builder: (v, r) {
        data = v;
        if (v == null) {
          return widget.builder(false);
        }
        final like = Like.fromJson(v, r.key!);
        return widget.builder(like.likedBy.contains(uid));
      },
    );
  }
}
