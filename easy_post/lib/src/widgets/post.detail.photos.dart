import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

class PostDetailPhotos extends StatelessWidget {
  const PostDetailPhotos({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              ...post.urls.asMap().entries.map((entry) {
                return SizedBox(
                    width: 200,
                    height: 200,
                    child: GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                            context: context,
                            pageBuilder: (context, _, __) {
                              return PhotoViewerScreen(
                                urls: post.urls,
                                selectedIndex: entry.key,
                              );
                            });
                      },
                      child: CachedNetworkImage(
                        imageUrl: entry.value,
                        fit: BoxFit.cover,
                      ),
                    ));
              }),
            ],
          ),
          if (post.youtubeUrl.isNotEmpty) ...{},
        ],
      ),
    );
  }
}
