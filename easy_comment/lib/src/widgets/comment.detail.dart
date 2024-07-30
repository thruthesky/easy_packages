import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// CommentDetail
///
/// This comment detail widget is used by many other widgets.
///
/// [displayAvatar] some of the parent widgets do not want to display the
/// user avatar. Like the [CommentWidgetDetail] widget that displays the
/// the user avatar by itself.
///
/// [displayReplyButton] some of the parent widgets do not want to display the
/// reply button. Like the [CommentWidgetDetail] widget that limits the
/// depth of the comment.
class CommentDetail extends StatelessWidget {
  const CommentDetail({
    super.key,
    required this.comment,
    this.displayAvatar = true,
    this.displayReplyButton = true,
  });

  final Comment comment;
  final bool displayAvatar;
  final bool displayReplyButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (displayAvatar) ...[
              UserAvatar.fromUid(
                uid: comment.uid,
                size: 42,
                radius: 18,
              ),
              const SizedBox(width: 8),
            ],
            Text(comment.createdAt.short),
          ],
        ),
        Text(comment.deleted ? 'comment deleted'.t : comment.content),
        DisplayPhotos(urls: comment.urls),
        Row(
          children: [
            if (displayReplyButton)
              TextButton(
                onPressed: () => CommentService.instance.showCommentEditDialog(
                  context: context,
                  parent: comment,
                  focusOnContent: true,
                ),
                child: Text('Reply'.t),
              ),
            TextButton(
              onPressed: () => CommentService.instance.showCommentEditDialog(
                context: context,
                parent: comment,
                focusOnContent: true,
              ),
              child: Text('Like'.tr(args: {'n': 3}, form: 3)),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              itemBuilder: (_) => [
                if (comment.isMine)
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'.t),
                  ),
                if (comment.isMine)
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
                  child: Text('Block'.t),
                ),
              ],
              child: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'edit') {
                  CommentService.instance.showCommentEditDialog(
                    context: context,
                    comment: comment,
                    focusOnContent: true,
                  );
                } else if (value == 'delete') {
                  final re = await confirm(
                    context: context,
                    title: Text('delete comment title'.t),
                    message: Text('delete comment message'.t),
                  );
                  if (re != true) return;

                  await comment.delete();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
