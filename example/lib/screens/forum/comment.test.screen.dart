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
    // final ref = Post.col.doc('0-console');
    // final ref = Post.col.doc('0-console-2');
    // final ref = Post.col.doc('0-con-3');
    // final ref = Post.col.doc('0-a');
    // final ref = Post.col.doc('0-b');
    // final ref = Post.col.doc('0-c');
    // final ref = Post.col.doc('0-5');
    final ref = Post.col.doc('o-3');
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommentTest'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text('Reference: ${ref.path}')),
          SliverToBoxAdapter(child: CommentInputBox(documentReference: ref)),
          CommentListTreeView(documentReference: ref),
        ],
      ),
    );
  }
}
