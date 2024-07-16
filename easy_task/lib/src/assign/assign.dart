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

  String id;
  String uid;
  String taskId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String assignedBy;
  String? groupId;

  Assign({
    required this.id,
    required this.uid,
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
      uid: json['uid'],
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
  /// See the README.en.md for details.
  static Future<DocumentReference> create({
    required String uid,
    required String taskId,
    String? groupId,
  }) async {
    final ref = await col.add({
      'uid': uid,
      'taskId': taskId,
      'status': AssignStatus.waiting,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'assignedBy': myUid,
      if (groupId != null) 'groupId': groupId,
    });
    await TaskService.instance.taskCol.doc(taskId).update({
      'assignTo': FieldValue.arrayUnion([uid]),
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
      'assignTo': FieldValue.arrayRemove([uid]),
    });

    // Must delete other related data like photos.
    await ref.delete();
  }
}
