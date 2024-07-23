import 'package:easy_post_v2/easy_post_v2.dart';
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
        PostDetailYoutube(post: post),
        Text(post.title),
        Text(post.content),
      ],
    );
  }
}
