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
            onPressed: () => PostService.instance.showPostCreateScreen(
              context: context,
              category: category,
              enableYoutubeUrl: true,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(40),
        //   child: SizedBox(
        //     height: 40,
        //     child: ListView(
        //       scrollDirection: Axis.horizontal,
        //       children: PostService.instance.categories.entries
        //           .map(
        //             (e) => TextButton(
        //               onPressed: () => setState(() => category = e.key),
        //               child: Text(e.value),
        //             ),
        //           )
        //           .toList(),
        //     ),
        //   ),
        // ),
      ),
      body: PostListView(
        category: category,
      ),
    );
  }
}
