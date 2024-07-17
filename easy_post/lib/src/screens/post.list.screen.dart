import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostListScreen extends StatefulWidget {
  static const String routeName = '/PostList';
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  String? category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostList'),
        actions: [
          IconButton(
            onPressed: () => PostService.instance.showPostEditScreen(
              context: context,
              category: category,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                TextButton(
                  onPressed: () => setState(() => category = 'qna'),
                  child: const Text('QnA'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'discussion'),
                  child: const Text('Discussion'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'news'),
                  child: const Text('News'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'news'),
                  child: const Text('News 2'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'news'),
                  child: const Text('News 3'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'news'),
                  child: const Text('News 4'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'news'),
                  child: const Text('News 5'),
                ),
                TextButton(
                  onPressed: () => setState(() => category = 'news'),
                  child: const Text('News 6'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: PostListView(category: category),
    );
  }
}
