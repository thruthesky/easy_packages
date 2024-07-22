import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:flutter/material.dart';

/// A list of comments for a post
///
/// To lessen the screen flickering (and the number of reads), we do the followings.
/// 1. get all the comments
/// 2. listen each comments for update
/// 3. listen new comments.
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

    // print('path: ${widget.post.commentsRef.path}');

    // Generate a flutter code with firebase realtime database that listens
    // to newly created data on the path 'comments/${widget.post.id}'
    // newCommentSubscription = Comment.col
    //     .limitToLast(1)
    //     .orderBy('order')
    //     .
    //     .listen(
    //   (event) {
    //     final comment = Comment.fromJson(
    //       event.snapshot.value as Map,
    //       event.snapshot.key!,
    //       postId: widget.post.id,
    //     );
    //     // Check if the comment is already in the list.
    //     final int index =
    //         comments!.indexWhere((element) => element.id == comment.id);
    //     // Exisiting comment. Do nothing. This happens on the first time.
    //     if (index > -1) return;
    //     // Add the comment to the list
    //     comments?.add(comment);
    //     // Sort the comments
    //     comments = Comment.sortComments(comments!);
    //     // This may trigger the screen flickering. It's okay. It's a rare case.
    //     setState(() {});
    //   },
    //   onError: (error) {
    //     dog('----> CommentListTreeView::initState() -> init() listen new comment: $error, path: ${widget.post.commentsRef.path}');
    //     throw error;
    //   },
    // );
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
    // on going work for collapsible comments
    // return SliverToBoxAdapter(
    //   child: ExpansionPanelList(
    //     children: parentComments!
    //         .map(
    //           (comment) => ExpansionPanel(
    //             headerBuilder: (context, expanded) =>
    //                 CommentView(post: widget.post, comment: comment),
    //             body: const Column(),
    //           ),
    //         )
    //         .toList(),
    //   ),
    // );

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
    // return SliverToBoxAdapter(
    //   child: NewCommentView(
    //     comments: comments!,
    //     post: widget.post,
    //   ),
    // );
  }
}
