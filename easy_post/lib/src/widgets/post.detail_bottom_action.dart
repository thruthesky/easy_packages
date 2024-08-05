import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostDetailBottomAction extends StatelessWidget {
  const PostDetailBottomAction({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PostCommentTextButton(
          post: post,
          child: Text('Reply'.t),
        ),
        PostLikeTextButton(
          post: post,
          child: Text(
            'Like'.tr(args: {'n': post.likeCount}, form: post.likeCount),
          ),
        ),
        const Spacer(),
        PostPopupMenuButton(
          post: post,
          child: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}
