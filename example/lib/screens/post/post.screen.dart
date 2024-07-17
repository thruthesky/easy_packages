import 'package:easy_forum/easy_forum.dart';
import 'package:example/screens/post/post.unit_test.screen.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

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
                    }),
                child: const Text('UnitTest')),
            ElevatedButton(
                onPressed: () => showGeneralDialog(
                    context: context,
                    pageBuilder: (_, __, ___) {
                      return const PostEditScreen();
                    }),
                child: const Text('Post Edit Screen'))
          ],
        ));
  }
}
