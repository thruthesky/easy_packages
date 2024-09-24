import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  static const String routeName = '/PostDetail';
  const PostDetailScreen({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    /// If the post has no youtube video, return the normal scallfold.
    if (post.hasYoutube == false) {
      return PostDetailScaffold(post: post);
    }

    /// If the post has youtube video, return the youtube fullscreen
    /// builder.
    return YoutubeFullscreenBuilder(
        post: post,
        builder: (context, player) {
          return PostDetailScaffold(post: post, youtubePlayer: player);
        });
  }
}

/// PostDetailScaffold
///
/// This widget displays the post details scaffold. The reason why it is
/// separated from the PostDetailScreen is to inject the youtube player
/// if the post has youtube video. If the post has no youtube video, it
/// will not inject the youtube player.
class PostDetailScaffold extends StatelessWidget {
  const PostDetailScaffold({super.key, required this.post, this.youtubePlayer});

  final Post post;
  final Widget? youtubePlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'.t),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: PostDetail(
                post: post,
                youtubePlayer: youtubePlayer,
              ),
            ),
          ),
          PostDetailCommentListTreeView(post: post),
        ],
      ),
      bottomNavigationBar: PostDetailCommentInputBox(post: post),
    );
  }
}
