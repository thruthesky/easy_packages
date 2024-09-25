import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostDetailCommentInputBox extends StatelessWidget {
  const PostDetailCommentInputBox({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    // TODO: showCommentEditDialog from Comment is not implemented yet.
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 16),
      child: CommentFakeInputBox(onTap: () {
        toast(context: context, message: const Text('Not Implmented yet.'));
        // CommentService.instance.showCommentInputBox(
        //   context: context,
        //   documentReference: post.ref,
        // );
      }),
    );
  }
}
