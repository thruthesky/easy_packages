import 'package:easy_comment/easy_comment.dart';
import 'package:flutter/material.dart';

class CommentListDetail extends StatelessWidget {
  const CommentListDetail({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: Column(
        children: [
          Text(comment.content),
          Text(comment.createdAt.toString()),
          Text('depth: ${comment.depth}'),
          Text('order: ${comment.order}'),
          CommentInputBox(
            parent: comment,
          )
        ],
      ),
    );
  }
}
