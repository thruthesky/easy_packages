import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

/// PostDoc is a widget that displays a post document.
///
/// [post] is the post document to display.
///
/// [sync] if it is passed as true, it will rebuild the widget when the post is
/// updated. If it is false, it will use FutureBuilder to get the post only one
/// time. If it is true, it will use StreamBuilder to get the post and rebuild
/// the widget when the post is updated.
class PostDoc extends StatelessWidget {
  const PostDoc({
    super.key,
    required this.post,
    required this.builder,
    this.sync = false,
  });

  final Post post;
  final Widget Function(Post) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder<Post>(
        initialData: post,
        stream: PostService.instance.col
            .doc(post.id)
            .snapshots()
            .map((snapshot) => Post.fromSnapshot(snapshot)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData == false) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          /// Got data from database
          Post? post = snapshot.data;

          return builder(post!);
        },
      );
    }

    return FutureBuilder<Post>(
      initialData: post,
      future: Post.get(post.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return builder(snapshot.data!);
      },
    );
  }
}
