import 'package:easy_category/easy_category.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostListScreen extends StatefulWidget {
  static const String routeName = '/PostList';
  const PostListScreen({super.key, required this.categories});

  final List<Category> categories;

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
          if (PostService.instance.postListActionButton != null) PostService.instance.postListActionButton!(category),
          IconButton(
            onPressed: () => PostService.instance.showPostCreateScreen(
              context: context,
              category: category,
              enableYoutubeUrl: true,
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
              children: widget.categories
                  .map(
                    (e) => TextButton(
                      onPressed: () => setState(() => category = e.id),
                      child: Text(e.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      body: PostListView(
        category: category,
      ),
    );
  }
}
