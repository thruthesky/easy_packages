import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';

/// CommentFakeInputBox
///
/// CommentFakeInputBox is a fake input box for comments.
///
///
class CommentFakeInputBox extends StatelessWidget {
  const CommentFakeInputBox({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            /// 사진 버튼
            const Icon(Icons.camera_alt),
            const SizedBox(width: 8),
            Expanded(child: Text('input comment'.t)),
            const Icon(Icons.send),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
