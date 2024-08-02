import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/buttons/post.comment_text_button.dart';
import 'package:easy_post_v2/src/widgets/buttons/post.like_text_button.dart';
import 'package:easyuser/easyuser.dart';
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
        PopupMenuButton<String>(
          itemBuilder: (_) => [
            if (post.isMine)
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'.t),
              ),
            if (post.isMine)
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'.t),
              ),
            PopupMenuItem(
              value: 'report',
              child: Text('Report'.t),
            ),
            PopupMenuItem(
              value: 'block',
              child: UserBlocked(
                otherUid: post.uid,
                builder: (blocked) => Text(blocked ? 'Unblock'.t : 'Block'.t),
              ),
            ),
          ],
          child: const Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 'edit') {
              PostService.instance
                  .showPostUpdateScreen(context: context, post: post);
            } else if (value == 'delete') {
              final re = await confirm(
                context: context,
                title: Text('Delete'.t),
                message: Text('Are you sure you wanted to delete this post?'.t),
              );
              if (re == false) return;
              await post.delete();
            } else if (value == 'report') {
              // await ReportService.instance.showReportDialog(
              //   context: context,
              //   documentReference: post.ref,
              // );
            } else if (value == 'block') {
              // await i.block(post.uid) BlockService.instance.showBlockDialog(
              //   context: context,
              //   documentReference: post.ref,
              // );

              await i.block(context: context, otherUid: post.uid);
            }
          },
        ),
      ],
    );
  }
}
