import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Edit comment dialog
///
/// This dialog is used to create or update a comment.
///
/// This dialog pops with `true` when the comment is created or updated.
///
/// [focusOnContent] is used to focus on the content field when the dialog is shown.
class CommentEditDialog extends StatefulWidget {
  const CommentEditDialog({
    super.key,
    this.documentReference,
    this.parent,
    this.comment,
    this.showUploadDialog,
    this.focusOnContent,
  }) : assert(
          comment == null || documentReference == null,
          'comment and documentReference cannot be both non-null. If comment is not null, it is update. If documentReference is not null, it is create.',
        );

  final DocumentReference? documentReference;
  final Comment? parent;
  final Comment? comment;
  final bool? showUploadDialog;
  final bool? focusOnContent;

  @override
  State<CommentEditDialog> createState() => _CommentEditDialogState();
}

class _CommentEditDialogState extends State<CommentEditDialog> {
  bool get isCreate => widget.comment == null;
  bool get isUpdate => !isCreate;

  double? progress;

  Comment? _comment;
  Comment get comment => _comment!;

  DocumentReference get documentReference =>
      widget.documentReference ?? widget.parent!.documentReference;

  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (isUpdate) {
      // 수정
      _comment = widget.comment;
      contentController.text = widget.comment!.content;
    } else {
      // 새 코멘트 생성.
      //
      // DB 에 존재하지 않는 Comment object 를 만들어 사용한다.
      // 글 작성 및 파일 업로드 등의 로직을 통일 할 수 있어서 이렇게 사용한다.
      _comment = Comment.fromDocumentReference(documentReference);
    }

    if (widget.showUploadDialog == true) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        upload();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: widget.focusOnContent == true,
              controller: contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comment',
              ),
              maxLines: 5,
              minLines: 3,
            ),
          ),

          /// 여기터 부터 코멘트 작성, 코멘트 사진 작성, 코멘트 좋아요, 신고, 차단

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: upload,
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 32,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if (isCreate) {
                      await Comment.create(
                        documentReference: documentReference,
                        content: contentController.text,
                        urls: comment.urls,
                        parent: widget.parent,
                      );
                    } else {
                      await comment.update(
                        content: contentController.text,
                        urls: comment.urls,
                      );
                    }

                    if (context.mounted) Navigator.of(context).pop(true);
                  },
                  child: Text(
                    isCreate ? 'T.writeComment' : 'T.save',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 16,
              child: Column(
                children: [
                  progress != null && progress!.isNaN == false
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LinearProgressIndicator(
                            value: progress,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              )),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DisplayEditableUploads(
              urls: comment.urls,
              onDelete: (url) async {
                setState(
                  () {
                    comment.urls.remove(url);
                  },
                );

                /// If isUpdate then delete the url from the list of comment.urls and silently update the server
                /// sometimes the user delete a url from post/comment but didnt save the post. so the url still exist but the actual image is already deleted
                /// so we need to update the post to remove the url from the server
                /// this will prevent error like the url still exist but the image is already deleted
                if (isUpdate) {
                  await comment.update(
                    urls: comment.urls,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> upload() async {
    final String? url = await StorageService.instance.upload(
      context: context,
      progress: (p) => setState(() => progress = p),
      complete: () => setState(() => progress = null),
    );
    if (url != null) {
      setState(() {
        progress = null;
        comment.urls.add(url);
      });
    }
  }
}