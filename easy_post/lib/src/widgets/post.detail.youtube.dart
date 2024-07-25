import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/post.detail.youtube_meta.dart';
import 'package:flutter/material.dart';

class PostDetailYoutube extends StatelessWidget {
  const PostDetailYoutube({super.key, required this.post, this.youtube});

  final Post post;
  final Widget? youtube;

  @override
  Widget build(BuildContext context) {
    if (post.youtubeUrl.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        youtube ??
            EasyYoutubePlayer(
              post: post,
              // autoPlay: PostService.instance.youtubeAutoPlay,
            ),
        if (post.urls.isEmpty) ...{PostDetailYoutubeMeta(post: post)}
      ],
    );
  }
}
