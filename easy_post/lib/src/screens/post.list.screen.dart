import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostListScreen extends StatefulWidget {
  static const String routeName = '/PostList';
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostList'),
        actions: [
          IconButton(
            onPressed: () => PostService.instance.showPostEditScreen(
              context: context,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Column(
        children: [
          Text("PostList"),
        ],
      ),
    );
  }
}
