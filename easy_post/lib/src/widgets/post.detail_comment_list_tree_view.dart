import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostDetailCommentListTreeView extends StatelessWidget {
  const PostDetailCommentListTreeView({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    // TODO: Since we changed to DatabaseReference, the CommentListTreeView is still using Firestore.
    // return CommentListTreeView(
    //   documentReference: post.ref,
    // );
    return const Placeholder();
  }
}
