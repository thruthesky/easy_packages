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
    required DocumentReference documentReference,
    Comment? parent,
    bool? showUploadDialog,
    bool? focusOnTextField,
  }) async {
    /// 로그인 확인
    if (i.registered) {
      final re = await UserService.instance.loginRequired!(
          context: context,
          action: 'showCommentCreateScreen',
          data: {
            'post': post,
            'parent': parent,
            'showUploadDialog': showUploadDialog,
            'focusOnTextField': focusOnTextField,
          });
      if (re != true) return false;
    }

    /// 관리자에 의해 차단되었는지 확인
    if (iam.disabled) {
      error(context: context, message: 'You are disabled.');
      return false;
    }

    /// 코멘트 생성 제한 확인
    if (await ActionLogService.instance.commentCreate.isOverLimit()) {
      return false;
    }

    ///
    if (context.mounted) {
      return showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true, // 중요: 이것이 있어야 키보드가 bottom sheet 을 위로 밀어 올린다.
        builder: (_) => CommentEditDialog(
          post: post,
          parent: parent,
          showUploadDialog: showUploadDialog,
          focusOnTextField: focusOnTextField,
        ),
      );
    }
    return null;
  }
}
