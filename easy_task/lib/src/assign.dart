import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';

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
  String id;
  String uid;
  String taskId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String assignedBy;

  Assign({
    required this.id,
    required this.uid,
    required this.taskId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedBy,
  });

  static final CollectionReference col = TaskService.instance.assignCol;
  DocumentReference get ref => col.doc(id);

  factory Assign.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return Assign.fromJson(json, snapshot.id);
  }

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
    );
  }

  /// Get an assign by its id
  static Future<Assign?> get(String id) async {
    final snapshot = await TaskService.instance.assignCol.doc(id).get();
    if (!snapshot.exists) return null;
    return Assign.fromSnapshot(snapshot);
  }

  // REVIEW
  // Getter using TaskId and UID?

  /// Assign a task to a user
  ///
  /// This method creates a new assign document and updates the 'assignTo'
  /// field of the task document.
  ///
  /// See the README.en.md for details.
  static Future<DocumentReference> create({
    required String uid,
    required String taskId,
  }) async {
    final ref = await TaskService.instance.assignCol.add({
      'uid': uid,
      'taskId': taskId,
      'status': AssignStatus.waiting,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'assignedBy': currentUser!.uid,
    });

    await TaskService.instance.taskCol.doc(taskId).update({
      'assignTo': FieldValue.arrayUnion([uid]),
    });

    return ref;
  }

  /// Change stauts
  Future<void> changeStatus(String status) async {
    await ref.update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete an assign
  ///
  ///
  Future<void> delete() async {
    TaskService.instance.taskCol.doc(taskId).update({
      'assignTo': FieldValue.arrayRemove([uid]),
    });

    // Must delete other related data like photos.
    await ref.delete();
  }
}
