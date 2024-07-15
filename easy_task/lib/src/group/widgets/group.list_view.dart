import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/src/defines.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskGroupQueryOptions {
  const TaskGroupQueryOptions({
    this.limit = 20,
    this.orderBy = 'updatedAt',
    this.orderByDescending = true,
    this.usersContain,
    this.moderatorUsersContain,
    this.invitedUsersContain,
    this.rejectedUsersContain,
  });

  final int limit;
  final String orderBy;
  final bool orderByDescending;
  final String? usersContain;
  final String? moderatorUsersContain;
  final String? invitedUsersContain;
  final String? rejectedUsersContain;

  /// Query Options for groups that invited me
  TaskGroupQueryOptions.invitedMe() : this(invitedUsersContain: myUid!);

  /// Query Options for groups that I rejected
  TaskGroupQueryOptions.myRejects() : this(rejectedUsersContain: myUid!);

  /// Query Options for groups that I
  /// either moderate or joined (accepted invitation).
  TaskGroupQueryOptions.involvesMe()
      : this(
          moderatorUsersContain: myUid!,
          usersContain: myUid,
        );

  /// Query Options for groups that I accepted
  TaskGroupQueryOptions.myJoins() : this(usersContain: myUid!);

  Map<String, dynamic> get options => {
        if (usersContain != null) "users": usersContain,
        if (moderatorUsersContain != null)
          "moderatorUsers": moderatorUsersContain,
        if (invitedUsersContain != null) "invitedUsers": invitedUsersContain,
        if (rejectedUsersContain != null) "rejectedUsers": rejectedUsersContain
      };

  Query get getQuery {
    Query groupQuery = Group.col;
    if (options.length == 1) {
      groupQuery = groupQuery.where(
        options.keys.first,
        arrayContains: options.values.first,
      );
    } else if (options.length >= 2) {
      groupQuery = groupQuery.where(
        Filter.or(
          Filter(
            options.keys.first,
            arrayContains: options.values.first,
          ),
          Filter(
            options.keys.elementAt(1),
            arrayContains: options.values.elementAt(1),
          ),
          options.length >= 3
              ? Filter(
                  options.keys.elementAt(2),
                  arrayContains: options.values.elementAt(2),
                )
              : null,
          options.length >= 4
              ? Filter(
                  options.keys.elementAt(3),
                  arrayContains: options.values.elementAt(3),
                )
              : null,
        ),
      );
    }
    groupQuery = groupQuery
        .orderBy(
          orderBy,
          descending: orderByDescending,
        )
        .limit(limit);
    return groupQuery;
  }
}

/// Group list view
///
/// This widget displays a list of groups using [ListView.separated] widget.
class TaskGroupListView extends StatelessWidget {
  const TaskGroupListView({
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
    this.queryOptions = const TaskGroupQueryOptions(),
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
  final TaskGroupQueryOptions queryOptions;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
      query: queryOptions.getQuery,
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
          return emptyBuilder?.call() ?? const Center(child: Text('Empty'));
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
