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
          builder: (user) => user == null
              ? const SizedBox.shrink()
              : UserAvatar(
                  user: user,
                ),
        ),
        Text(post.title),
        Text(post.content),
      ],
    );
  }
}
