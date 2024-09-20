import 'package:easy_like/easy_like.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';

class PostLikeTextButton extends StatelessWidget {
  /// `PostLikeTextButton` this button allows to do like and unlike the post
  ///
  /// `post` this contains the post information to be subject to the like and unlike
  /// action.
  ///
  const PostLikeTextButton({
    super.key,
    required this.post,
    required this.child,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.isSemanticButton,
  });

  final Post post;
  final Widget child;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final bool? isSemanticButton;

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
        // TODO : DocumentReference in Like is in Firestore
        // final like = Like(documentReference: post.ref);
        // await like.like();
      },
      child: child,
    );
  }
}
