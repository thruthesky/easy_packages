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
  CollectionReference taskCol =
      FirebaseFirestore.instance.collection('todo-task');

  /// CollectionReference for Assign docs
  CollectionReference assignCol =
      FirebaseFirestore.instance.collection('todo-assign');

  /// Group relationship collection
  ///
  /// All tasks must belong to a group and the task can be assigned to users
  /// in the same group.
  CollectionReference groupCol =
      FirebaseFirestore.instance.collection('todo-group');

  /// CollectionReference for Invitation docs
  ///
  /// Before adding to group, the user must accept
  CollectionReference invitationCol =
      FirebaseFirestore.instance.collection('todo-group-invitation');

  /// Get assingees of the task
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

  Future<void> acceptGroupInvitation(String groupId) async {
    final invitationSnapshot = await invitationCol
        .where('groupId', isEqualTo: groupId)
        .where('uid', isEqualTo: myUid!)
        .get();
    if (invitationSnapshot.docs.isEmpty) {
      throw 'You were not invited to this group.';
    }

    // Delete invitations to group
    final futures = invitationSnapshot.docs
        .map((doc) => Invitation.fromSnapshot(doc).delete())
        .toList();

    final group = await Group.get(groupId);
    if (group == null) {
      throw 'Group not found.';
    }

    // Add myself
    futures.add(group.addMember(myUid!));

    await Future.wait(futures);
  }

  Future<void> declineGroupInvitation(String groupId) async {
    final invitationSnapshot = await invitationCol
        .where('groupId', isEqualTo: groupId)
        .where('uid', isEqualTo: myUid!)
        .get();
    if (invitationSnapshot.docs.isEmpty) {
      throw 'You were not invited to this group.';
    }

    // Delete invitations to group
    final futureDeletes = invitationSnapshot.docs
        .map((doc) => Invitation.fromSnapshot(doc).delete())
        .toList();

    await Future.wait(futureDeletes);
  }

  Future<List<DocumentReference>?> assignGroup({
    required String taskId,
    required String groupId,
  }) async {
    final group = await Group.get(groupId);
    if (group == null) {
      throw 'Group not found.';
    }
    final memberUids = group.members;
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
