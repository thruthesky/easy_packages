import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_comment/easy_comment.dart';
import 'package:easyuser/easyuser.dart';

import 'package:flutter/material.dart';

/// Comment view
///
/// Note, to display the comemnt tree, it gets the whole comments of the post and
/// do some computation to display the comment tree. It does not look like a heavy compulation
/// but it needs an attention.
///
/// 주의, 코멘트 트리를 표시 할 때, 가로 선과 커브선이 딱 맞물리지 않는 경우가 있다. 특히, 아바타의 크기가
/// 변경되는 경우, 가로선과 커브선이 잘 안맞는데, 적절히 조정해야 한다.
class CommentTreeDetail extends StatefulWidget {
  const CommentTreeDetail({
    super.key,
    required this.documentReference,
    required this.comment,
    required this.comments,
    required this.index,
    this.onCreate,
  });

  final DocumentReference documentReference;
  final Comment comment;
  final List<Comment> comments;
  final int index;
  final Function? onCreate;

  @override
  State<CommentTreeDetail> createState() => _CommentTreeDetailState();
}

class _CommentTreeDetailState extends State<CommentTreeDetail> {
  int? previousNoOfLikes;

  double lineWidth = 2;
  Color get verticalLineColor =>
      Theme.of(context).colorScheme.outline.withAlpha(100);
  bool get isFirstParent => widget.comment.depth == 0;
  bool get isChild => !isFirstParent;
  bool get hasChild => widget.comment.hasChild;

  List<Comment> parents = [];

  @override
  void initState() {
    super.initState();

    /// Save the accendent comments of the current comment into the [parents] variable
    Comment? parent = widget.comment;
    while (parent != null) {
      parents.add(parent);
      if (parent.parentId == null) break;
      parent = widget.comments.firstWhereOrNull(
        (cmt) => cmt.id == parent!.parentId,
      );
    }
    parents = parents.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget.comment.depth; i++)
              indentedVerticalLine(i),

            /// curved line
            if (isChild)
              CommentCurvedLine(
                lineWidth: lineWidth - .5,
                color: verticalLineColor,
              ),

            Column(
              children: [
                /// 코멘트 목록을 tree 형태로 세로 라인을 그릴 때에는
                /// 아바타 밑에서 부터 세로 라인을 그려야 자연 스럽다.
                /// 즉, CommentDetail 위젯에는 사진을 표시하지 않도록 옵션을 주어야 한다.
                UserAvatar.fromUid(
                  uid: widget.comment.uid,
                  size: 44,
                  radius: 20,
                ),

                /// 자식이 있다면, 아바타 아래에 세로 라인을 그린다. 즉, 아바타 아래의 세로 라인은 여기서 그린다.
                if (hasChild)
                  Expanded(
                    child: VerticalDivider(
                      color: verticalLineColor,
                      width: lineWidth,
                      thickness: lineWidth,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CommentDetail(
                comment: widget.comment,
                displayAvatar: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 세로 라인을 긋는다.
  ///
  /// [depth] 는 코멘트의 깊이를 나타내는 것으로,
  /// 현재 코멘트의 depth 가 3 이라면, 0 부터 1 과 2 총 세번 호출 된다.
  Widget indentedVerticalLine(int depth) {
    return SizedBox(
      width: depth == 0 ? 23 : 39,
      child: Column(
        /// 세로 라인을 오른쪽으로 붙인다. 그래서 커브 라인이 세로 라인에 붙게 한다.
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (maybeDrawVerticalLine(depth))
            Expanded(
              child: VerticalDivider(
                width: lineWidth,
                color: verticalLineColor,
                thickness: lineWidth,
              ),
            ),
          if (maybeDrawShortVerticalLine(depth))
            Container(
              width: lineWidth,
              height: 5,
              decoration: BoxDecoration(
                color: verticalLineColor,
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
  bool maybeDrawVerticalLine(int depth) {
    final currComment = widget.comment;
    final parents =
        CommentService.instance.getParents(currComment, widget.comments);
    if (parents.isEmpty) return false;
    final depthComment = parents[depth];

    if (currComment.depth == depth) {
      return false;
    }
    for (int i = widget.index + 1; i < widget.comments.length; i++) {
      final target = widget.comments[i];
      if (target.depth == depth + 1 && target.parentId == depthComment.id) {
        return true;
      }
    }
    return false;
  }

  bool maybeDrawShortVerticalLine(int depth) {
    return widget.comment.depth - 1 == depth;
  }
}

class CommentCurvedLine extends StatelessWidget {
  const CommentCurvedLine({
    super.key,
    required this.lineWidth,
    required this.color,
  });

  final double lineWidth;
  final Color color;

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
                  bottom: BorderSide(width: lineWidth, color: color),
                  left: BorderSide(width: lineWidth, color: color),
                ),

                /// For making a curve to its edge
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
