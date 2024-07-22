import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:flutter/material.dart';

/// CommentListTreeView
class CommentListTreeView extends StatefulWidget {
  const CommentListTreeView({super.key, required this.documentReference});

  final DocumentReference documentReference;

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
    comments = await CommentService.instance
        .getAll(documentReference: widget.documentReference);
    if (mounted) {
      setState(() {});
    }

    // Listens to newly created data on the path 'comments' collection
    // of the documentReference
    newCommentSubscription = Comment.col
        .where('documentReference', isEqualTo: widget.documentReference)
        .orderBy('order')
        .snapshots()
        .listen((event) {
      comments = CommentService.instance.fromQuerySnapshot(event);
      setState(() {});
    });
  }

  @override
  void dispose() {
    newCommentSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (comments == null) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    }
    if (comments!.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text('T.commentEmptyList.tr'),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return CommentTreeDetail(
            documentReference: widget.documentReference,
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
