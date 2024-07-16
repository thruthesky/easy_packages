import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class AssignQueryOptions {
  const AssignQueryOptions({
    this.taskId,
    this.limit = 20,
    this.orderBy = 'createdAt',
    this.orderByDescending = true,
    this.uid,
    this.status,
  });

  final String? taskId;
  final int limit;
  final String orderBy;
  final bool orderByDescending;
  final String? uid;
  final String? status;

  /// Query Options for Assigns that I created.
  AssignQueryOptions.myAssigns() : this(uid: myUid!);

  /// Query Options for tasks that are assigned to me
  AssignQueryOptions.assignedToMe() : this(uid: myUid!);

  Query get getQuery {
    Query assignQuery = Assign.col;
    if (taskId != null) {
      assignQuery = assignQuery.where(
        'taskId',
        isEqualTo: taskId,
      );
    }
    if (uid != null) {
      assignQuery = assignQuery.where(
        'uid',
        isEqualTo: uid,
      );
    }
    if (status != null) {
      assignQuery = assignQuery.where(
        'status',
        isEqualTo: status,
      );
    }
    assignQuery = assignQuery
        .orderBy(
          orderBy,
          descending: orderByDescending,
        )
        .limit(limit);
    return assignQuery;
  }
}
