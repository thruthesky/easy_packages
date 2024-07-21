import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentListView extends StatefulWidget {
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
  State<CommentListView> createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {
  Map<String, Comment> mapComments = {};
  List<Comment> get comments => mapComments.values.toList();

  @override
  Widget build(BuildContext context) {
    Query query = Comment.col
        .where('documentReference', isEqualTo: widget.documentReference);
    query = query.orderBy('order');

    return FirestoreQueryBuilder(
      query: query,
      pageSize: widget.pageSize,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return widget.loadingBuilder?.call() ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          dog('Error: ${snapshot.error}');
          return widget.errorBuilder?.call(snapshot.error.toString()) ??
              Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.docs.isEmpty && !snapshot.hasMore) {
          return widget.emptyBuilder?.call() ??
              const Center(child: Text('empty list'));
        }

        return ListView.separated(
          itemCount: snapshot.docs.length,
          separatorBuilder: (context, index) =>
              widget.separatorBuilder?.call(context, index) ??
              const SizedBox.shrink(),
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          controller: widget.controller,
          primary: widget.primary,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          padding: widget.padding,
          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
          addRepaintBoundaries: widget.addRepaintBoundaries,
          addSemanticIndexes: widget.addSemanticIndexes,
          cacheExtent: widget.cacheExtent,
          dragStartBehavior: widget.dragStartBehavior,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          itemBuilder: (context, index) {
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              snapshot.fetchMore();
            }

            final comment = Comment.fromSnapshot(snapshot.docs[index]);
            mapComments[comment.id] = comment;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // if (comment.depth > 1) const VerticalDivider(),
                  // Column(
                  //   children: [
                  //     Container(
                  //       width: (comment.depth - 1) * 16,
                  //       height: 8,
                  //       decoration: BoxDecoration(
                  //         border: Border(
                  //           right: BorderSide(
                  //             color: Colors.grey[800]!,
                  //             width: 2,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // if (comment.depth > 1) const CommentCurvedLine(),
                  // if (comment.depth > 1 && comment.hasChild)
                  //   VerticalLine(comment: comment),

                  for (int i = 0; i < comment.depth; i++)
                    _indentedVerticalLine(i, comment, index),

                  const SizedBox(width: 8),
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
              ),
            );
          },
        );
      },
    );
  }

  /// 세로 라인을 긋는다.
  ///
  /// [depth] 는 코멘트의 깊이를 나타내는 것으로,
  /// 현재 코멘트의 depth 가 3 이라면, 0 부터 1 과 2 총 세번 호출 된다.
  Widget _indentedVerticalLine(int depth, Comment comment, int commentIndex) {
    return SizedBox(
      width: depth == 0 ? 21 : 30,
      child: Column(
        /// 세로 라인을 오른쪽으로 붙인다. 그래서 커브 라인이 세로 라인에 붙게 한다.
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (maybeDrawVerticalLine(depth, comment, commentIndex))
            Expanded(
              child: VerticalDivider(
                width: 2,
                color: Colors.grey[800],
                thickness: 2,
              ),
            ),
          if (maybeDrawShortVerticalLine(depth, comment))
            Container(
              width: 2,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius:

                    /// For making a curve to its edge
                    const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Return true if the vertical line should be drawn.
  ///
  /// Logic:
  /// 루프 앞 단계의 상위에 sibiling 이 있고, 같은 단계의 다음 형제가 마지막 자식이 아니면,
  ///
  /// 루프 단계는 0 부터 시작.
  /// 나의 단계도 0 부터 시작.
  ///
  /// 공식:
  ///   - 현재 루프 단계에서,
  ///   - 나의 하위에,
  ///   - 현재 루프 + 1 단계에 자식이 있으면 해당 루프 단계에 긋는다.
  ///   - 단, 현재 루프 단계가 나와 같은 depth 이면 긋지 않는다.
  ///
  /// 예)
  ///   - 나의 단계 0. 현재 루프 0. 긋지 않는다. 나의 depth 와 루프 depth 가 동일하기 때문이다.
  ///   - 나의 단계 1. 현재 루프 0. 나의 하위에 0 + 1 = 1 단계 자식이 있으면 0 단계에 긋는다. (단, 나의 depth 와 같으면 긋지 않는다.)
  ///   - 나의 단계 2. 루프 단계 0. 1 단계에 하위 자식이 있어도 나와 depth 가 같으면, 긋지 않는다. 다르면 긋는다.
  ///   - 나의 단계 2. 루프 단계 1. 2 단계에 하위 자식이 있는 1단계에 긋는다.
  ///   - 나의 단계 2. 루프 단계 2. 3 단계에 하위 자식이 있는 2단계에 긋는다.
  ///   - 나의 단계 3. 루프 단계 2. 3 단계에 하위 자식이 있으면, 2 단계에 긋는다.
  bool maybeDrawVerticalLine(int depth, Comment comment, int commentIndex) {
    final currComment = comment;
    final parents = Comment.getParents(currComment, comments);
    final depthComment = parents[depth];

    if (currComment.depth == depth) {
      return false;
    }
    for (int i = commentIndex + 1; i < comments.length; i++) {
      final target = comments[i];
      if (target.depth == depth + 1 && target.parentId == depthComment.id) {
        return true;
      }
    }
    return false;
  }

  bool maybeDrawShortVerticalLine(int depth, Comment comment) {
    return comment.depth - 1 == depth;
  }
}

class VerticalLine extends StatelessWidget {
  const VerticalLine({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      color: Colors.blue[800],
    );
  }
}

class CommentCurvedLine extends StatelessWidget {
  const CommentCurvedLine({super.key, this.lineWidth = 2, this.color});

  final double lineWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: Stack(
        children: [
          Positioned(
            left: -lineWidth,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: lineWidth, color: color ?? Colors.grey[800]!),
                  left: BorderSide(
                      width: lineWidth, color: color ?? Colors.grey[800]!),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
