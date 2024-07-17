import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostEditScreen extends StatefulWidget {
  static const String routeName = '/PostEdit';
  const PostEditScreen({super.key});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final categoryController = TextEditingController();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

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
              ),
              TextField(
                controller: titleController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: contentController,
                minLines: 5,
                maxLines: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  await Post.create(
                    category: categoryController.text,
                    title: titleController.text,
                    content: contentController.text,
                  );
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
