import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostDetailYoutube extends StatelessWidget {
  const PostDetailYoutube({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (post.youtubeUrl.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        YoutubePlayer(
          post: post,
          // autoPlay: PostService.instance.youtubeAutoPlay,
        ),
        const SizedBox(height: 16),
        Text(
          post.youtube['title'],
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          post.youtube['name'],
          style: Theme.of(context).textTheme.labelMedium,
        ),
        // todo fromat view count
        Text(
          '${post.youtube['viewCount']} views',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
