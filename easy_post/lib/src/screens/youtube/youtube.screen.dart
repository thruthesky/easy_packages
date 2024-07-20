import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class YoutubeScreen extends StatefulWidget {
  static const String routeName = '/YouTube';

  const YoutubeScreen({super.key, required this.post});

  final Post post;

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await PostService.instance.showPostEditScreen(
                context: context,
                category: 'youtube',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // separate the youtube player so it can be reused
            YoutubePlayer(post: widget.post),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${widget.post.youtube['title']}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.post.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.post.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () {
                  PostService.instance.showPostDetailScreen(
                      context: context, post: widget.post);
                },
                child: const Text('See Comments')),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('You May Also Like'),
            ),
            const SizedBox(
              height: 16,
            ),
            PostListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              category: 'youtube',
              separatorBuilder: (context, index) => const SizedBox.shrink(),
              itemBuilder: (post, index) {
                if (post.id == widget.post.id) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.replace(
                          context,
                          oldRoute: ModalRoute.of(context)!,
                          newRoute: MaterialPageRoute(
                            builder: (context) => YoutubeScreen(post: post),
                          ),
                        );
                      },
                      child: YoutubeTile(post: post)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
