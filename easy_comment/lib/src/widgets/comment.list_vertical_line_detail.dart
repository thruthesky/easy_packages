import 'package:easy_comment/easy_comment.dart';
import 'package:flutter/material.dart';

class CommentListVerticalLineDetail extends StatelessWidget {
  const CommentListVerticalLineDetail({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < comment.depth; i++)
            VerticalDivider(
              color: Colors.grey[400],
              thickness: 2,
            ),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: CommentDetail(comment: comment)),
        ],
      ),
    );
  }
}
