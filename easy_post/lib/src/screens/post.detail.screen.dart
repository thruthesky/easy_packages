import 'dart:async';

import 'package:easy_comment/easy_comment.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
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
    return YoutubeFullscreenBuilder(
        post: post,
        builder: (context, widget) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('PostDetail'),
            ),
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: PostDetail(
                      post: post,
                      youtube: widget,
                    ),
                  ),
                ),
                CommentListTreeView(
                  documentReference: post.ref,
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: CommentFakeInputBox(onTap: () {
                CommentService.instance.showCommentEditDialog(
                  context: context,
                  documentReference: post.ref,
                );
              }),
            ),
          );
        });
  }
}
