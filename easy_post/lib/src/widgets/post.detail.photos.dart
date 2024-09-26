import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// contains the  post photo to display in the post details screen
///
///
class PostDetailPhotos extends StatelessWidget {
  const PostDetailPhotos({
    super.key,
    required this.urls,
  });

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();
    final double halfWidth = MediaQuery.of(context).size.width / 2 - 16;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (urls.length == 1)
          SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            height: 200,
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, _, __) {
                    return PhotoViewerScreen(
                      urls: urls,
                      selectedIndex: 0,
                    );
                  },
                );
              },
              child: CachedNetworkImage(
                imageUrl: urls[0],
                fit: BoxFit.cover,
              ),
            ),
          )
        else if (urls.length == 2)
          Wrap(
            children: urls.asMap().entries.map((entry) {
              return SizedBox(
                width: halfWidth,
                height: 200,
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, _, __) {
                        return PhotoViewerScreen(
                          urls: urls,
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
        else if (urls.length > 2)
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
                          urls: urls,
                          selectedIndex: 0,
                        );
                      },
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: urls[0],
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
                          urls: urls,
                          selectedIndex: 1,
                        );
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        width: halfWidth,
                        height: halfWidth,
                        imageUrl: urls[1],
                        fit: BoxFit.cover,
                      ),
                      if (urls.length > 2)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              '+${urls.length - 2}',
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
