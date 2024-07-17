import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:example/screens/forum/post.unit_test.screen.dart';
import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () => showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return const PostUniteTestScreen();
                      },
                    ),
                child: const Text('UnitTest')),
            ElevatedButton(
              onPressed: () => PostService.instance.showPostEditScreen(
                context: context,
                category: null,
              ),
              child: const Text('Post Edit Screen'),
            ),
            ElevatedButton(
              onPressed: () => PostService.instance.showPostListScreen(
                context: context,
              ),
              child: const Text('Post List Screen'),
            ),
          ],
        ));
  }
}
