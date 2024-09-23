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
    return const Text('TODO: implement PostDetailCommentInputBox');
    // TODO: Since we changed to DatabaseReference, the CommentListTreeView is still using Firestore.
    // return SafeArea(
    //   minimum: const EdgeInsets.only(bottom: 16),
    //   child: CommentFakeInputBox(onTap: () {
    //     CommentService.instance.showCommentEditDialog(
    //       context: context,
    //       documentReference: post.ref,
    //     );
    //   }),
    // );
  }
}
