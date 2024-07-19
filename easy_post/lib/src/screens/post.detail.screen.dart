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
      body: Column(
        children: [
          UserDoc(
            uid: widget.post.uid,
            builder: (user) => user == null
                ? const SizedBox.shrink()
                : UserAvatar(
                    user: user,
                  ),
          ),
          Text(widget.post.title),
          Text(widget.post.content),

          /// Display comment input box
          /// TODO from here.
          // CommentInputBox(post: widget.post),
        ],
      ),
    );
  }
}
