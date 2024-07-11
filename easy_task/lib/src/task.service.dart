import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_task/easy_task.dart';

/// To-do service
///
/// This service is the only service for the whole to-do feature.

class TaskService {
  static TaskService? _instance;
  static TaskService get instance => _instance ??= TaskService._();

  TaskService._();

  ///
  CollectionReference taskCol =
      FirebaseFirestore.instance.collection('todo-task');

  ///
  CollectionReference assignCol =
      FirebaseFirestore.instance.collection('todo-assign');

  /// Group relationship collection
  ///
  /// All tasks must belong to a group and the task can be assigned to users
  /// in the same group.
  CollectionReference groupCol =
      FirebaseFirestore.instance.collection('todo-group');

  /// Get assingees of the task
  Future<List<Assign>> getAssigns(String taskId) async {
    final snapshot = await assignCol.where('taskId', isEqualTo: taskId).get();
    return snapshot.docs.map((e) => Assign.fromSnapshot(e)).toList();
  }

  Future<Assign?> getMyAssign(String taskId) async {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await assignCol
        .where('taskId', isEqualTo: taskId)
        .where('uid', isEqualTo: myUid)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Assign.fromSnapshot(snapshot.docs[0]);
  }
}
