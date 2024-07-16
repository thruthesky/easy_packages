import 'package:easy_forum/easy_forum.dart';
import 'package:easy_helpers/easy_helpers.dart';
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
                onPressed: () async {
                  final re = await createPost();

                  dog('$re');
                },
                child: const Text('Test Create'))
          ],
        ));
  }
}
