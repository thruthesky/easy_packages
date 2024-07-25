import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

/// contains the youtube meta data to display in post details
class PostDetailYoutubeMeta extends StatelessWidget {
  const PostDetailYoutubeMeta({super.key, required this.post});

  final Post post;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          post.youtube['title'],
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          post.youtube['name'],
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          '${formatViews(post.youtube['viewCount'])} views',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
