import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({
    super.key,
    required this.documentReference,
    this.pageSize = 40,
    this.loadingBuilder,
    this.errorBuilder,
    this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.itemBuilder,
    this.emptyBuilder,
  });

  final DocumentReference documentReference;
  final int pageSize;
  final Widget Function()? loadingBuilder;
  final Widget Function(String)? errorBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final Widget Function(Comment, int)? itemBuilder;
  final Widget Function()? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    Query query =
        Comment.col.where('documentReference', isEqualTo: documentReference);
    query = query.orderBy('order');

    return FirestoreQueryBuilder(
      query: query,
      pageSize: pageSize,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return loadingBuilder?.call() ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          dog('Error: ${snapshot.error}');
          return errorBuilder?.call(snapshot.error.toString()) ??
              Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.docs.isEmpty && !snapshot.hasMore) {
          return emptyBuilder?.call() ??
              const Center(child: Text('empty list'));
        }

        return ListView.separated(
          itemCount: snapshot.docs.length,
          separatorBuilder: (context, index) =>
              separatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          itemBuilder: (context, index) {
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              snapshot.fetchMore();
            }

            final comment = Comment.fromSnapshot(snapshot.docs[index]);

            return IntrinsicHeight(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (comment.depth > 1)
                  Row(
                    children: [
                      for (int i = 0; i < comment.depth - 1; i++)
                        SizedBox(
                          width: 16,
                          height: 16,
                          // color: Colors.grey[300],
                          child: Center(
                              child: Text(
                            // '－', //   '➖', //   '-', //
                            '•',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[400]),
                          )),
                        ),
                    ],
                  ),

                if (comment.depth > 1)
                  Icon(
                    Icons.subdirectory_arrow_right,
                    // Icons.arrow_right_rounded,
                    // Icons.arrow_right_alt_rounded,
                    // Icons.chevron_right_outlined,
                    // Icons.keyboard_double_arrow_right_rounded,
                    color: Colors.grey[700],
                  ),

                const SizedBox(
                  width: 8,
                ),

                /// Comment
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.content),
                    Text(comment.createdAt.toString()),
                    TextButton(
                      onPressed: () =>
                          CommentService.instance.showCommentEditDialog(
                        context: context,
                        parent: comment,
                        focusOnContent: true,
                      ),
                      child: const Text('Reply'),
                    ),
                  ],
                ),
              ],
            ));
          },
        );
      },
    );
  }
}
