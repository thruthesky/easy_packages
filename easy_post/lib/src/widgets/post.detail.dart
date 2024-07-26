import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/post.detail.photos.dart';
import 'package:easy_post_v2/src/widgets/post.detail.youtube_meta.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// This widget that contains the overall details of the post
/// contains youtube video, youtube meta data, post title, post content , post photos
class PostDetail extends StatefulWidget {
  /// `post` this contains the post inforamtion
  ///
  /// `youtube` for youtube player,this use to pass the youtube player comming from the
  /// `YoutubeFullscreenBuilder` to be reused if this widget is not provide it will
  /// use a new youtube player
  const PostDetail({super.key, required this.post, this.youtubePlayer});

  final Post post;
  final Widget? youtubePlayer;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserDoc(
            uid: widget.post.uid,
            builder: (user) {
              return user == null
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        UserAvatar(
                          user: user,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.displayName),
                              Text('${user.createdAt}'),
                            ],
                          ),
                        )
                      ],
                    );
            }),
        const SizedBox(height: 16),
        if (widget.post.deleted) ...{
          const SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(
              child: Text('This Post has been deleted.'),
            ),
          ),
        } else ...{
          PostDetailPhotos(post: widget.post),
          if (widget.post.hasYoutube && widget.youtubePlayer != null)
            widget.youtubePlayer!,
          PostDetailYoutubeMeta(post: widget.post),
          const SizedBox(
            height: 16,
          ),
          if (widget.post.title.isNotEmpty) Text(widget.post.title),
          if (widget.post.content.isNotEmpty) Text(widget.post.content),
        },
        Row(
          children: [
            TextButton(
              onPressed: () {
                CommentService.instance.showCommentEditDialog(
                  context: context,
                  documentReference: widget.post.ref,
                  focusOnContent: false,
                );
              },
              child: Text('Reply'.t),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Like'.tr(args: {'n': 3}, form: 3)),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              itemBuilder: (_) => [
                if (widget.post.isMine)
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'.t),
                  ),
                if (widget.post.isMine)
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
                  PostService.instance.showPostUpdateScreen(
                      context: context, post: widget.post);
                } else if (value == 'delete') {
                  final re = await confirm(
                    context: context,
                    title: 'Delete'.t,
                    message: 'Are you sure you wanted to delete this post?'.t,
                  );
                  if (re == false) return;
                  await widget.post.delete();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
