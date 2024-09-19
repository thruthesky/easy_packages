import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:easy_locale/easy_locale.dart';

/// A list view of users that the login user has blocked.
///
/// It supports most of the [ListView] widget parameters.
///
class BlockListView extends StatelessWidget {
  const BlockListView({
    super.key,
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
  final Widget Function(User, int)? itemBuilder;
  final Widget Function()? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: i.blockChanges,
      builder: (context, snapshot) {
        final blocks = i.blocks;

        if (blocks.isEmpty) {
          return Center(
            child: Text('block list view is empty'.t),
          );
        }

        return ListView.separated(
          itemCount: blocks.length,
          separatorBuilder: (context, index) => separatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
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
            final uid = blocks.keys.elementAt(index);

            return ListTile(
              leading: UserAvatar.fromUid(uid: uid),
              title: DisplayName(uid: uid),
              subtitle: Text('Blocked at: ${(blocks[uid]['blockedAt'].toDate() as DateTime).short}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  i.block(context: context, otherUid: uid);
                },
              ),
            );
          },
        );
      },
    );
  }
}
