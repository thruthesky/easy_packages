import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  static const String routeName = '/PostDetail';
  const PostDetailScreen({
    super.key,
    required this.post,
  });

  final Post post;
  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostDetail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDoc.sync(
                uid: widget.post.uid,
                builder: (user) {
                  return Row(
                    children: [
                      UserAvatar(
                        user: user!,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.post.createdAt}',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ],
                      ),
                    ],
                  );
                }),
            const SizedBox(height: 8),
            Text(
              widget.post.title,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(widget.post.content),
            if (widget.post.category == 'youtube' &&
                widget.post.youtubeUrl != '') ...{
              YoutubePlayer(
                post: widget.post,
                thumbnail: CachedNetworkImage(
                  imageUrl: widget.post.youtube['hd'],
                ),
              ),
            },
            // ElevatedButton(
            //     onPressed: () {
            //       CommentService.instance.showCommentEditDialog(
            //           context: context,
            //           documentReference: Post.col.doc(widget.post.id));
            //     },
            //     child: const Text('comment')),
            // Expanded(
            //     child: CommentListView(
            //   documentReference: Post.col.doc(
            //     widget.post.id,
            //   ),
            // ))
          ],
        ),
      ),
    );
  }
}
