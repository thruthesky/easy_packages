import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// FirestoreLimitedListView
///
/// Why?
/// If you want to display the 10 most new documents from Firetore, It's not
/// easy with [FirestoreListView] and [FirestoreQueryBuilder]. So, this widget
/// is created to solve this problem.
///
/// How?
///
/// A ListView that limits the number of documents to be displayed as a list view.
///
/// This rebuilds the items in realtime as the data changes.
///
/// Example:
/// ```dart
/// return FirestoreLimitedListView(
///   query: ChatRoomQuery.unread(),
///   limit: 3,
///   separatorBuilder: (p0, p1) => const SizedBox(height: 6),
///   itemBuilder: (context, doc) => ChatJoinListTile(
///     room: ChatRoom.fromSnapshot(doc),
///   ),
///   padding: const EdgeInsets.symmetric(
///     horizontal: sm,
///     vertical: xs,
///   ),
/// );
/// ```
class FirestoreLimitedListView extends StatelessWidget {
  const FirestoreLimitedListView({
    super.key,
    required this.query,
    required this.limit,
    this.loadingBuilder,
    this.errorBuilder,
    this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
    this.padding = const EdgeInsets.all(0),
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    required this.itemBuilder,
    this.emptyBuilder,
  });

  final Query query;
  final int limit;

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
  final Widget Function(BuildContext, DocumentSnapshot) itemBuilder;
  final Widget Function()? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.limit(limit).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('Something went wrong: ${snapshot.error}');
          return errorBuilder?.call(
                snapshot.error.toString(),
              ) ??
              Text('${'something went wrong'}: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return loadingBuilder?.call() ??
              const CircularProgressIndicator.adaptive();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyBuilder?.call() ?? const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
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
          itemBuilder: (listViewContext, index) {
            final doc = docs[index];
            return itemBuilder(
              listViewContext,
              doc,
            );
          },
        );
      },
    );
  }
}
