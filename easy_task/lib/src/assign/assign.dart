import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class AssignStatus {
  static const waiting = 'waiting';
  static const progress = 'progress';
  static const finished = 'finished';
  static const review = 'review';
  static const closed = 'closed';

  static List<String> values() => [
        waiting,
        progress,
        finished,
        review,
        closed,
      ];

  AssignStatus._();
}

class Assign {
  static final CollectionReference col = TaskService.instance.assignCol;
  DocumentReference get ref => col.doc(id);

  final String id;
  final String assignTo;
  final String taskId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String assignedBy;
  final String? groupId;

  Assign({
    required this.id,
    required this.assignTo,
    required this.taskId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedBy,
    this.groupId,
  });

  factory Assign.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp? createdAt = json['createdAt'];
    final Timestamp? updatedAt = json['updatedAt'];
    return Assign(
      id: id,
      assignTo: json['assignTo'],
      taskId: json['taskId'],
      status: json['status'],
      createdAt: createdAt == null ? DateTime.now() : createdAt.toDate(),
      updatedAt: updatedAt == null ? DateTime.now() : updatedAt.toDate(),
      assignedBy: json['assignedBy'] ?? '',
      groupId: json['groupId'],
    );
  }

  factory Assign.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return Assign.fromJson(json, snapshot.id);
  }

  /// Assign a task to a user
  ///
  /// This method creates a new assign document and updates the 'assignTo'
  /// field of the task document.
  ///
  /// [assignTo] is the uid of the user to assign the task to.
  ///
  /// See the README.en.md for details.
  static Future<DocumentReference> create({
    required String assignTo,
    required Task task,
    String? groupId,
  }) async {
    final ref = await col.add({
      'assignTo': assignTo,
      'taskId': task.id,
      'status': AssignStatus.waiting,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'assignedBy': myUid,
      if (groupId != null) 'groupId': groupId,
    });
    await TaskService.instance.taskCol.doc(task.id).update({
      'assignTo': FieldValue.arrayUnion([assignTo]),
    });
    return ref;
  }

  /// Get an assign by its id
  static Future<Assign?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) return null;
    return Assign.fromSnapshot(snapshot);
  }

  /// Change status
  Future<void> changeStatus(String status) async {
    await ref.update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete an assign
  ///
  Future<void> delete() async {
    TaskService.instance.taskCol.doc(taskId).update({
      'assignTo': FieldValue.arrayRemove([assignTo]),
    });

    // Must delete other related data like photos.
    await ref.delete();
  }
}
