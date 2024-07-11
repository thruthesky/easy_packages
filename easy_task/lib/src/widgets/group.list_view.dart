import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class GroupQueryOptions {
  GroupQueryOptions({
    this.limit = 20,
    this.orderBy = 'createdAt',
    this.orderByDescending = true,
    this.membersContain,
    this.moderatorUid,
  });

  final int limit;
  final String orderBy;
  final bool orderByDescending;
  final String? membersContain;
  final String? moderatorUid;
}

/// Group list view
///
/// This widget displays a list of groups using [ListView.separated] widget.
class GroupListView extends StatelessWidget {
  const GroupListView({
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
  final Widget Function(Group group, int index)? itemBuilder;
  final Widget Function()? emptyBuilder;
  final GroupQueryOptions? queryOptions;

  Query get getQuery {
    Query groupQuery = Group.col;
    if (queryOptions != null) {
      if (queryOptions!.membersContain != null &&
          queryOptions!.moderatorUid != null) {
        groupQuery = groupQuery.where(
          Filter.or(
            Filter(
              "members",
              arrayContains: queryOptions!.membersContain!,
            ),
            Filter(
              "moderatorUid",
              isEqualTo: queryOptions!.moderatorUid!,
            ),
          ),
        );
      } else if (queryOptions!.membersContain != null) {
        groupQuery = groupQuery.where(
          "members",
          arrayContains: queryOptions!.membersContain!,
        );
      } else if (queryOptions!.moderatorUid != null) {
        groupQuery = groupQuery.where(
          "moderatorUid",
          isEqualTo: queryOptions!.moderatorUid!,
        );
      }
      groupQuery = groupQuery
          .orderBy(
            queryOptions!.orderBy,
            descending: queryOptions!.orderByDescending,
          )
          .limit(queryOptions!.limit);
    }
    return groupQuery;
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
      query: getQuery,
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

            final group = Group.fromSnapshot(snapshot.docs[index]);

            return itemBuilder?.call(group, index) ??
                GestureDetector(
                  onTap: () async {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (_, __, ___) => GroupDetailScreen(
                        group: group,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      border: Border.all(width: 1),
                    ),
                    child: Text("Group is ${group.name}"),
                  ),
                );
          },
        );
      },
    );
  }
}
