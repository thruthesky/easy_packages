import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/src/defines.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskQueryOptions {
  const TaskQueryOptions({
    this.limit = 20,
    this.orderBy = 'createdAt',
    this.orderByDescending = true,
    this.assignToContains,
    this.assignTo,
    this.notAssignTo,
    this.uid,
    this.groupId,
  });

  final int limit;
  final String orderBy;
  final bool orderByDescending;

  /// [assignToContains] is for where clause
  /// where `assignTo` contains it.
  final String? assignToContains;

  /// [assignTo] is for where clause
  /// where `assignTo` isEqualTo it.
  final List<String>? assignTo;

  /// [notAssignTo] is for where clause
  /// where `assignTo` isNotEqualTo it.
  final List<String>? notAssignTo;

  /// [uid] is for the creator of the task
  final String? uid;

  /// [groupId] is for the group of the task
  final String? groupId;

  /// Query Options for tasks that I created.
  TaskQueryOptions.myCreates() : this(uid: myUid!);

  /// Query Options for tasks that are assigned to me
  TaskQueryOptions.assignedToMe() : this(assignToContains: myUid!);

  /// Query Options for tasks that I created and assigned to me.
  TaskQueryOptions.myCreatesAndAssignedToMe()
      : this(
          uid: myUid!,
          assignToContains: myUid!,
        );

  /// Query Options for tasks that I created and assigned to others.
  /// Note that this may still query tasks that were assigned to
  /// others but were assigned to me as well.
  TaskQueryOptions.myAssignsToOthers()
      : this(
          assignToContains: myUid!,
          notAssignTo: [myUid!],
        );

  /// Query Options for tasks that I created but unassigned.
  TaskQueryOptions.myCreatesButUnassigned()
      : this(
          uid: myUid!,
          assignTo: [],
        );

  Query get getQuery {
    Query taskQuery = Task.col;
    if (assignToContains != null) {
      taskQuery = taskQuery.where(
        "assignTo",
        arrayContains: assignToContains!,
      );
    }
    if (assignTo != null) {
      taskQuery = taskQuery.where(
        "assignTo",
        isEqualTo: assignTo!,
      );
    }
    // TODO review
    if (notAssignTo != null) {
      taskQuery = taskQuery.where(
        "assignTo",
        isNotEqualTo: notAssignTo!,
      );
    }
    if (uid != null) {
      taskQuery = taskQuery.where(
        "uid",
        isEqualTo: uid!,
      );
    }
    if (groupId != null) {
      taskQuery = taskQuery.where(
        "groupId",
        isEqualTo: groupId!,
      );
    }
    taskQuery = taskQuery
        .orderBy(
          orderBy,
          descending: orderByDescending,
        )
        .limit(limit);
    return taskQuery;
  }
}

/// Task list view
///
/// This widget displays a list of tasks using [ListView.separated] widget.
class TaskListView extends StatelessWidget {
  const TaskListView({
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
    this.queryOptions = const TaskQueryOptions(),
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
  final Widget Function(Task task, int index)? itemBuilder;
  final Widget Function()? emptyBuilder;
  final TaskQueryOptions queryOptions;

  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

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

            final task = Task.fromSnapshot(snapshot.docs[index]);

            return itemBuilder?.call(task, index) ??
                GestureDetector(
                  onTap: () async {
                    if (task.uid == myUid) {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (_, __, ___) => TaskDetailScreen(
                          task: task,
                        ),
                      );
                    } else if (task.assignTo.contains(myUid)) {
                      final assign =
                          await TaskService.instance.getMyAssignFrom(task.id);
                      if (assign == null) return;
                      if (!context.mounted) return;
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (_, __, ___) => AssignDetailScreen(
                          assign: assign,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      border: Border.all(width: 1),
                    ),
                    child: Text("Task is ${task.title}"),
                  ),
                );
          },
        );
      },
    );
  }
}
