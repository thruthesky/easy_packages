import 'package:easy_post_v2/easy_post_v2.dart';
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
    final ref = Post.col.child('0-e');
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommentTest'),
      ),
      body:

          /// 트리 형태 세로 라인 코멘트
          //     CustomScrollView(
          //   slivers: [
          //     SliverToBoxAdapter(child: Text('Reference: ${ref.path}')),
          //     SliverToBoxAdapter(child: CommentInputBox(documentReference: ref)),
          //     // 트리 형태 세로 라인 표시
          //     CommentListTreeView(documentReference: ref),
          //   ],
          // ),

          // 일반 코멘트
          Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text('Reference: ${ref.path}'),
            // CommentInputBox(documentReference: ref),
            // CommentListView(
            //   // documentReference: ref,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (comment, index) {
            //     // return CommentListDetail(comment: comment);
            //     // return CommentListArrowDetail(comment: comment);
            //     return CommentListVerticalLineDetail(comment: comment);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
