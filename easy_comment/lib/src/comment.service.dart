import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class CommentService {
  static CommentService? _instance;
  static CommentService get instance => _instance ??= CommentService._();

  CommentService._();

  bool initialized = false;
  CollectionReference get col =>
      FirebaseFirestore.instance.collection('comments');

  /// Returns true if comment is created or updated.
  Future<bool?> showCommentEditDialog({
    required BuildContext context,
    DocumentReference? documentReference,
    Comment? parent,
    Comment? comment,
    bool? showUploadDialog,
    bool? focusOnContent,
  }) async {
    /// 로그인 확인
    if (i.registered == false) {
      throw 'comment-edit/login-required You must be logged in to comment.';
    }

    ///
    if (context.mounted) {
      return showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true, // 중요: 이것이 있어야 키보드가 bottom sheet 을 위로 밀어 올린다.
        builder: (_) => CommentEditDialog(
          documentReference: documentReference,
          parent: parent,
          comment: comment,
          showUploadDialog: showUploadDialog,
          focusOnContent: focusOnContent,
        ),
      );
    }
    return null;
  }
}
