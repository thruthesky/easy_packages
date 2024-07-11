import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class AssignQueryOptions {
  const AssignQueryOptions({
    this.task,
    this.limit = 20,
    this.orderBy = 'createdAt',
    this.orderByDescending = true,
    this.uid,
  });

  final Task? task;
  final int limit;
  final String orderBy;
  final bool orderByDescending;
  final String? uid;
}

class AssignListView extends StatelessWidget {
  const AssignListView({
    super.key,
    this.pageSize = 20,
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.itemBuilder,
    this.emptyBuilder,
    this.queryOptions,
  });

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
  final Widget Function(Assign assign, int index)? itemBuilder;
  final Widget Function()? emptyBuilder;
  final AssignQueryOptions? queryOptions;

  @override
  Widget build(BuildContext context) {
    Query assignQuery = Assign.col;
    if (queryOptions != null) {
      if (queryOptions!.task != null) {
        assignQuery = assignQuery.where(
          'taskId',
          isEqualTo: queryOptions!.task!.id,
        );
      }
      if (queryOptions!.uid != null) {
        assignQuery = assignQuery.where(
          'uid',
          isEqualTo: queryOptions!.uid,
        );
      }
      assignQuery = assignQuery
          .orderBy(
            queryOptions!.orderBy,
            descending: queryOptions!.orderByDescending,
          )
          .limit(queryOptions!.limit);
    }
    return FirestoreQueryBuilder(
      query: assignQuery,
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
              const Center(child: Text('todo list is empty'));
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
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }

            final assign = Assign.fromSnapshot(snapshot.docs[index]);

            return GestureDetector(
              onTap: () {
                // Navigator.of(context).pushNamed(
                //   TaskDetailScreen.routeName,
                //   arguments: task,
                // );

                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) => AssignDetailScreen(
                    assign: assign,
                  ),
                );
              },
              child: itemBuilder?.call(assign, index) ??
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      border: Border.all(),
                    ),
                    child: Text("${assign.uid}: ${assign.status}"),
                  ),
            );
          },
        );
      },
    );
  }
}
