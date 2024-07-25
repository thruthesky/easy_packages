import 'package:easy_category/easy_category.dart';
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
                categories: [
                  Category(id: 'qna', name: 'QnA'),
                  Category(id: 'discussion', name: 'Discussion'),
                  Category(id: 'youtube', name: 'Youtube'),
                  Category(id: 'buyandsell', name: 'Buy and Sell'),
                  Category(id: 'job', name: 'Jobs'),
                  Category(id: 'news', name: 'News'),
                ],
              ),
              child: const Text('Post List Screen'),
            ),
            ElevatedButton(
              onPressed: () => PostService.instance
                  .showYoutubeListScreen(context: context, category: 'youtube'),
              child: const Text('Youtube List Screen'),
            ),
          ],
        ));
  }
}
