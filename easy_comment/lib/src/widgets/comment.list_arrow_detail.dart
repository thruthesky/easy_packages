import 'package:easy_comment/easy_comment.dart';
import 'package:flutter/material.dart';

class CommentListArrowDetail extends StatelessWidget {
  const CommentListArrowDetail({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (comment.depth > 1)
          Row(
            children: [
              for (int i = 0; i < comment.depth - 1; i++)
                SizedBox(
                  width: 16,
                  height: 16,
                  // color: Colors.grey[300],
                  child: Center(
                      child: Text(
                    // '－', //   '➖', //   '-', //
                    '•',
                    style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                  )),
                ),
            ],
          ),
        if (comment.depth > 1)
          Icon(
            Icons.subdirectory_arrow_right,
            // Icons.arrow_right_rounded,
            // Icons.arrow_right_alt_rounded,
            // Icons.chevron_right_outlined,
            // Icons.keyboard_double_arrow_right_rounded,
            color: Colors.grey[700],
          ),
        const SizedBox(
          width: 8,
        ),
        CommentDetail(comment: comment),
      ],
    );
  }
}
