import 'package:flutter/material.dart';

class CommentFakeInputBox extends StatelessWidget {
  const CommentFakeInputBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        /// 텍스트 입력 버튼 액션
        // await ForumService.instance.showCommentCreateScreen(
        //   context: context,
        //   post: post,
        //   focusOnTextField: true,
        // );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            /// 사진 버튼
            IconButton(
              onPressed: () async {
                // await ForumService.instance.showCommentCreateScreen(
                //   context: context,
                //   post: post,
                //   showUploadDialog: true,
                // );
              },
              icon: const Icon(Icons.camera_alt),
            ),
            const Expanded(child: Text('Write a comment')),
            const Icon(Icons.send),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
