import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Generate a comment input box in a StatefulWidget which takes a category as a parameter and a documentReference,
/// including a text field and a submit button, and
/// cammera button for uploading images using StorageService from easy_storage.
///
/// The comment input box is displayed in a column.
///
class CommentInputBox extends StatefulWidget {
  const CommentInputBox({
    super.key,
    this.documentReference,
    this.parent,
    this.comment,
  });

  final DocumentReference? documentReference;
  final Comment? parent;
  final Comment? comment;

  @override
  State<CommentInputBox> createState() => _CommentInputBoxState();
}

class _CommentInputBoxState extends State<CommentInputBox> {
  final commentController = TextEditingController();
  final storageService = StorageService.instance;

  /// Get document reference
  DocumentReference get documentReference =>
      widget.documentReference ??
      widget.parent?.documentReference ??
      widget.comment!.documentReference;

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () async {
                // final image = await storageService.pickImage();
                // if (image != null) {
                //   await storageService.uploadImage(
                //     context: context,
                //     ref: widget.category,
                //     field: 'comment',
                //     id: widget.documentReference,
                //     image: image,
                //   );
                // }
              },
            ),
            Expanded(
              child: TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Enter your comment',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                await Comment.create(
                  documentReference: documentReference,
                  parent: widget.parent,
                  content: commentController.text,
                );
                commentController.clear();
              },
            ),
          ],
        ),
      ],
    );
  }
}