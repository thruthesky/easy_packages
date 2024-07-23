import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/post.detail.photos.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserDoc(
            uid: post.uid,
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
              onPressed: () {},
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
              onSelected: (value) {},
            ),
          ],
        ),
      ],
    );
  }
}
