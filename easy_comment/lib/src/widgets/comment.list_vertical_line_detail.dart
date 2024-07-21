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
        children: [
          if (comment.depth > 1)
            Row(
              children: [
                for (int i = 0; i < comment.depth - 1; i++)

                  /// Draw a vertical line using Container widget
                  SizedBox(
                    width: 16,
                    child: Column(
                      children: [
                        Expanded(
                          child: VerticalDivider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          const SizedBox(
            width: 8,
          ),
          CommentDetail(comment: comment),
        ],
      ),
    );
  }
}
