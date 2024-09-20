import 'dart:async';

import 'package:easy_comment/easy_comment.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// CommentListTreeView
class CommentListTreeView extends StatefulWidget {
  const CommentListTreeView({super.key, required this.parentReference});

  final DatabaseReference parentReference;

  @override
  State<CommentListTreeView> createState() => _CommentListTreeViewState();
}

class _CommentListTreeViewState extends State<CommentListTreeView> {
  List<Comment>? comments;
  StreamSubscription? newCommentSubscription;

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    // Getting all the comments first
    comments = await CommentService.instance.getAll(parentReference: widget.parentReference);
    if (mounted) {
      setState(() {});
    }

    /// TODO: show comment edit dialog: refactoring-database
    // Listens to newly created data on the path 'comments' collection
    // of the parentReference
    // newCommentSubscription = Comment.col
    //     .where('parentReference', isEqualTo: widget.parentReference)
    //     .orderBy('order')
    //     .snapshots()
    //     .listen((event) {
    //   comments = CommentService.instance.fromQuerySnapshot(event);
    // setState(() {});
    // });
  }

  @override
  void dispose() {
    newCommentSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (comments == null) {
      return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
    }
    if (comments!.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text('comment list is empty'.t),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return CommentTreeDetail(
            parentReference: widget.parentReference,
            comment: comments![index],
            comments: comments!,
            index: index,
          );
        },
        childCount: comments!.length,
      ),
    );
  }
}
