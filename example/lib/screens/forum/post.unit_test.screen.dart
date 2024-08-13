import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_post_v2/unit_test/post_test.dart';
import 'package:easy_youtube/easy_youtube.dart';
import 'package:flutter/material.dart';

class PostUniteTestScreen extends StatelessWidget {
  const PostUniteTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              createPost();
            },
            child: const Text('Test Create'),
          ),
          ElevatedButton(
            onPressed: () async {
              updatePost();
            },
            child: const Text('Test Update'),
          ),
          ElevatedButton(
            onPressed: () async {
              createYouyubePost();
            },
            child: const Text('Youtube Post Test'),
          ),
          ElevatedButton(
            onPressed: () async {
              deletePost();
            },
            child: const Text('Delete Post Test'),
          ),
          ElevatedButton(
            onPressed: () async {
              final youtube =
                  Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

              print('youtube id: ${youtube.getVideoId()}');

              // youtube.getVideoId();
              final snippet = await youtube.getSnippet(
                apiKey: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
              );
              dog('snippet ---- $snippet');
            },
            child: const Text('Get Easy Youtube Post Test'),
          )
        ],
      ),
    );
  }
}
