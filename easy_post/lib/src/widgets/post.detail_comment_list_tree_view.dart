import 'package:easy_comment/easy_comment.dart';
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
    return CommentListTreeView(
      documentReference: post.ref,
    );
  }
}
