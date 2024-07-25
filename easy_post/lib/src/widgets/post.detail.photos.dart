import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// contains the  post photo to display in the post details screen
///
///
class PostDetailPhotos extends StatelessWidget {
  const PostDetailPhotos({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (post.urls.isEmpty) return const SizedBox.shrink();
    final double halfWidth = MediaQuery.of(context).size.width / 2 - 16;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.urls.length == 1)
          SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            height: 200,
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, _, __) {
                    return PhotoViewerScreen(
                      urls: post.urls,
                      selectedIndex: 0,
                    );
                  },
                );
              },
              child: CachedNetworkImage(
                imageUrl: post.urls[0],
                fit: BoxFit.cover,
              ),
            ),
          )
        else if (post.urls.length == 2)
          Wrap(
            children: post.urls.asMap().entries.map((entry) {
              return SizedBox(
                width: halfWidth,
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
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: entry.value,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          )
        else if (post.urls.length > 2)
          Wrap(
            children: [
              SizedBox(
                width: halfWidth,
                height: 200,
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, _, __) {
                        return PhotoViewerScreen(
                          urls: post.urls,
                          selectedIndex: 0,
                        );
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: post.urls[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: halfWidth,
                height: 200,
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, _, __) {
                        return PhotoViewerScreen(
                          urls: post.urls,
                          selectedIndex: 1,
                        );
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        width: halfWidth,
                        imageUrl: post.urls[1],
                        fit: BoxFit.cover,
                      ),
                      if (post.urls.length > 2)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              '+${post.urls.length - 2}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}
