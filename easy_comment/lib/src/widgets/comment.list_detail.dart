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
      margin: EdgeInsets.fromLTRB(24.0 * comment.depth, 8, 0, 8),
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: CommentDetail(comment: comment),
    );
  }
}
