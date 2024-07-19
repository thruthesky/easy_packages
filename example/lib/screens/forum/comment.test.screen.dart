import 'package:easy_comment/easy_comment.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class CommentTestScreen extends StatefulWidget {
  static const String routeName = '/CommentTest';
  const CommentTestScreen({super.key});

  @override
  State<CommentTestScreen> createState() => _CommentTestScreenState();
}

class _CommentTestScreenState extends State<CommentTestScreen> {
  @override
  Widget build(BuildContext context) {
    // final ref = my.ref;
    // final ref = Post.col.doc('1zsZ2YMplgZN6D6bdZIn');
    final ref = Post.col.doc('0-console');
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommentTest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: MyDocReady(
          builder: () => ListView(
            children: [
              Text('Reference: ${ref.path}'),
              const SizedBox(height: 24),
              CommentInputBox(
                documentReference: ref,
              ),
              CommentListView(
                documentReference: ref,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
