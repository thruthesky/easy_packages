import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

/// easy_post provide a youtube screen
/// `post`
/// `autoPlay` if true the current playing youtube video will automatically play
class YoutubeListScreen extends StatefulWidget {
  static const String routeName = '/YouTube';

  const YoutubeListScreen({super.key, this.autoPlay = false});

  final bool autoPlay;

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
        physics: const NeverScrollableScrollPhysics(),
        // change query
        category: 'youtube',
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        itemBuilder: (post, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: GestureDetector(
              onTap: () async {
                await PostService.instance
                    .showPostDetailScreen(context: context, post: post);
              },
              child: YoutubeTile(post: post),
            ),
          );
        },
      ),
    );
  }
}
