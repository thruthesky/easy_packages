import 'dart:async';

import 'package:easy_comment/easy_comment.dart';
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

        // post photo
        PostDetailYoutube(post: post),
        PostDetailPhotos(post: post),
        const SizedBox(height: 16),
        Text(post.title),
        Text(post.content),

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
              child: const Text('Reply'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Like'),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              child: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  PostService.instance
                      .showPostUpdateScreen(context: context, post: post);
                } else if (value == 'delete') {
                  post.delete();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
