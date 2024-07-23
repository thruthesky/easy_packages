import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class YoutubeTile extends StatelessWidget {
  const YoutubeTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        height: 200,
        child: CachedNetworkImage(
          imageUrl: post.youtube['hd'],
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDoc(
            builder: (user) => UserAvatar(user: user!),
            uid: post.uid,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            ),
          ),
          //todo foramt duration
          Text(
            '${post.youtube['duration']}',
          )
        ],
      ),
    ]);
  }
}