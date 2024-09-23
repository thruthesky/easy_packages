import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({
    super.key,
    required this.parentReference,
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

  final DatabaseReference parentReference;
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
    return const SizedBox.shrink();
    // TODO: show comment edit dialog: refactoring-database
    // Query query = Comment.col.where('parentReference', isEqualTo: parentReference);
    // query = query.orderBy('order');

    // return FirestoreQueryBuilder(
    //   query: query,
    //   pageSize: pageSize,
    //   builder: (context, snapshot, _) {
    //     if (snapshot.isFetching) {
    //       return loadingBuilder?.call() ?? const Center(child: CircularProgressIndicator.adaptive());
    //     }

    //     if (snapshot.hasError) {
    //       dog('Error: ${snapshot.error}');
    //       return errorBuilder?.call(snapshot.error.toString()) ?? Text('Something went wrong! ${snapshot.error}');
    //     }

    //     if (snapshot.hasData && snapshot.docs.isEmpty && !snapshot.hasMore) {
    //       return emptyBuilder?.call() ?? const Center(child: Text('empty list'));
    //     }

    //     return ListView.separated(
    //       itemCount: snapshot.docs.length,
    //       separatorBuilder: (context, index) => separatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
    //       scrollDirection: scrollDirection,
    //       reverse: reverse,
    //       controller: controller,
    //       primary: primary,
    //       physics: physics,
    //       shrinkWrap: shrinkWrap,
    //       padding: padding,
    //       addAutomaticKeepAlives: addAutomaticKeepAlives,
    //       addRepaintBoundaries: addRepaintBoundaries,
    //       addSemanticIndexes: addSemanticIndexes,
    //       cacheExtent: cacheExtent,
    //       dragStartBehavior: dragStartBehavior,
    //       keyboardDismissBehavior: keyboardDismissBehavior,
    //       restorationId: restorationId,
    //       clipBehavior: clipBehavior,
    //       itemBuilder: (context, index) {
    //         if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
    //           snapshot.fetchMore();
    //         }

    //         final comment = Comment.fromSnapshot(snapshot.docs[index]);

    //         return itemBuilder?.call(comment, index) ?? CommentListDetail(comment: comment);
    //       },
    //     );
    //   },
    // );
  }
}
