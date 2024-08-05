import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class PostPopupMenuButton extends StatelessWidget {
  /// `PostPopupMenuButton` use this widget to display a pop up that contains
  /// the edit, delete , report , block the post
  ///
  /// `post` information of the post
  ///
  /// `child` the child widget the will trigger the popup example icon, text
  ///
  ///
  /// if you want to use this default postpopupmenubutton and customize the rest you can do so
  /// but if you want to cuztomize this widget itself you can create your  just copy the code
  ///
  const PostPopupMenuButton({
    super.key,
    required this.post,
    required this.child,
  });

  final Post post;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
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
      child: child,
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
    );
  }
}
