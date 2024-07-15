import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class TaskQueryOptions {
  const TaskQueryOptions({
    this.limit = 20,
    this.orderBy = 'updatedAt',
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
