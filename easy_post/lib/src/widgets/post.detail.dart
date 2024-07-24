import 'dart:async';

import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/post.detail.photos.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late Post post;

  StreamSubscription? postSubscription;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postSubscription = PostService.instance.col
        .doc(widget.post.id)
        .snapshots()
        .listen((event) {
      post = Post.fromSnapshot(event);
      setState(() {});
    });
  }

  @override
  void dispose() {
    postSubscription?.cancel();
    super.dispose();
  }

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

        if (post.deleted) ...{
          const SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(
              child: Text('This Post has been deleted.'),
            ),
          ),
        } else ...{
          PostDetailYoutube(post: post),
          PostDetailPhotos(post: post),
          const SizedBox(height: 16),
          Text(post.title),
          Text(post.content),
        },
        // post photo

        Row(
          children: [
            TextButton(
              onPressed: () {
                CommentService.instance.showCommentEditDialog(
                  context: context,
                  documentReference: post.ref,
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
                  child: Text('Block'.t),
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
                    title: 'Delete'.t,
                    message: 'Are you sure you wanted to delete this post?'.t,
                  );
                  if (re == false) return;
                  await post.delete();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
