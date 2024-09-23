import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

/// Post Comment Text Button
///
/// Reason:
///
/// Purpose:
class PostCommentTextButton extends StatelessWidget {
  const PostCommentTextButton({
    super.key,
    required this.post,
    required this.child,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton,
    this.onCreated,
  });

  final Post post;
  final Widget child;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final bool? isSemanticButton;
  final Function(bool?)? onCreated;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      isSemanticButton: isSemanticButton,
      onPressed: () async {
        // TODO : DocumentReference in CommentService
        // final re = await CommentService.instance.showCommentEditDialog(
        //   context: context,
        //   documentReference: post.ref,
        //   focusOnContent: false,
        // );
        const re = false;
        onCreated?.call(re);
      },
      child: child,
    );
  }
}
