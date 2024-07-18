import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostEditScreen extends StatefulWidget {
  static const String routeName = '/PostEdit';
  const PostEditScreen({super.key, required this.category});

  final String? category;

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final categoryController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final youtubeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      categoryController.text = widget.category!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PostEdit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: 'Category'.t,
                  labelText: 'Category'.t,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: contentController,
                minLines: 5,
                maxLines: 8,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: youtubeController,
                decoration: InputDecoration(
                  hintText: 'Youtube'.t,
                  labelText: 'Youtube'.t,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final ref = await Post.create(
                    category: categoryController.text,
                    title: titleController.text,
                    content: contentController.text,
                    youtubeUrl: youtubeController.text,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop(ref);
                  }
                },
                child: Text('Created'.t),
              )
            ],
          ),
        ),
      ),
    );
  }
}
