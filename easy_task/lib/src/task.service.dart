import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/easy_task.dart';

/// To-do service
///
/// This service is the only service for the whole to-do feature.
class TaskService {
  static TaskService? _instance;
  static TaskService get instance => _instance ??= TaskService._();

  TaskService._();

  /// CollectionReference for Task docs
  CollectionReference taskCol = FirebaseFirestore.instance.collection('task');

  /// CollectionReference for Assign docs
  CollectionReference assignCol =
      FirebaseFirestore.instance.collection('task-assign');

  /// CollectionReference for Task User Group
  CollectionReference userGroupCol =
      FirebaseFirestore.instance.collection('task-user-group');

  /// Get assignees of the task
  Future<List<Assign>> getAssigns(String taskId) async {
    final snapshot = await assignCol.where('taskId', isEqualTo: taskId).get();
    return snapshot.docs.map((e) => Assign.fromSnapshot(e)).toList();
  }

  Future<Assign?> getMyAssignFrom(String taskId) async {
    final snapshot = await assignCol
        .where('taskId', isEqualTo: taskId)
        .where('uid', isEqualTo: myUid)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Assign.fromSnapshot(snapshot.docs[0]);
  }

  Future<List<DocumentReference>?> assignGroup({
    required String taskId,
    required String groupId,
  }) async {
    final group = await TaskUserGroup.get(groupId);
    if (group == null) {
      throw 'Group not found.';
    }
    final memberUids = group.users;
    final futures = memberUids.map(
      (uid) => Assign.create(
        uid: uid,
        taskId: taskId,
        groupId: groupId,
      ),
    );
    return await Future.wait(futures);
  }
}
