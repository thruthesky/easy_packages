import 'package:easy_comment/easy_comment.dart';
import 'package:flutter/material.dart';

class CommentDetail extends StatelessWidget {
  const CommentDetail({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(comment.content),
        Text(comment.createdAt.toString()),
        TextButton(
          onPressed: () => CommentService.instance.showCommentEditDialog(
            context: context,
            parent: comment,
            focusOnContent: true,
          ),
          child: const Text('Reply'),
        ),
      ],
    );
  }
}
