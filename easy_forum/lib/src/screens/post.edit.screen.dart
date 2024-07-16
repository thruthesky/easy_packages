import 'package:flutter/material.dart';

class PostEditScreen extends StatefulWidget {
  static const String routeName = '/PostEdit';
  const PostEditScreen({super.key});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostEdit'),
      ),
      body: const Column(
        children: [
          Text("PostEdit"),
        ],
      ),
    );
  }
}
