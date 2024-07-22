import 'package:easy_post_v2/unit_test/post_test.dart';
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
          )
        ],
      ),
    );
  }
}
