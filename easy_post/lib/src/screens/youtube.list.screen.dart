import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

/// easy_post provide a youtube screen
///
class YoutubeListScreen extends StatefulWidget {
  static const String routeName = '/YouTube';

  const YoutubeListScreen({super.key, required this.category});

  final String category;

  @override
  State<YoutubeListScreen> createState() => _YoutubeListScreenState();
}

class _YoutubeListScreenState extends State<YoutubeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube'.t),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await PostService.instance.showPostCreateScreen(
                context: context,
                category: 'youtube',
              );
            },
          ),
        ],
      ),
      body: PostListView(
        category: 'youtube',
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        itemBuilder: (post, index) {
          if (post.youtubeUrl.isEmpty) {
            return PostListTile(post: post);
          } else {
            return YoutubeTile(post: post);
          }
        },
      ),
    );
  }
}
