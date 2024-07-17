import 'package:easy_forum/easy_forum.dart';
import 'package:flutter/material.dart';

class PostListTile extends StatelessWidget {
  const PostListTile({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.content),
      // onTap: ()=> ,
    );
  }
}
