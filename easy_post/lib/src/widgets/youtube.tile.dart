import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class YoutubeTile extends StatelessWidget {
  const YoutubeTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PostService.instance.showPostDetailScreen(context: context, post: post);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: CachedNetworkImage(
                imageUrl: getThumbnailUrl(post),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.youtube['title'] ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        post.youtube['name'] ?? '',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        abbrivateStringOrNumber(
                            post.youtube['statistics']['viewCount'] ?? 0),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                Text(
                  formatISO8601ToDuration(
                      post.youtube['contentDetails']['duration'] ?? 0),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
