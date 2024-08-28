import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';

class TaskUserGroup {
  static CollectionReference get col =>
      FirebaseFirestore.instance.collection('taskUserGroups');

  DocumentReference get ref => col.doc(id);

  TaskUserGroup({
    required this.id,
    required this.creator,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.uids,
    required this.inviteUids,
  });

  /// [id] is the group id
  final String id;

  /// [creator] is the uid of the user who created this group
  final String creator;

  /// [title] is the group title
  final String title;

  /// [description] is the group description
  final String description;

  /// [createdAt] is the date and time when the group is created
  final DateTime createdAt;

  /// [updatedAt] is the date and time when the group is updated
  final DateTime updatedAt;

  /// [uids] is the uid of the users accepted the invite
  final List<String> uids;

  /// [inviteUids] is the uid of the user that has pending invite
  final List<String> inviteUids;

  factory TaskUserGroup.fromSnapshot(DocumentSnapshot snapshot) {
    return TaskUserGroup.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  /// Get the task object from the json.
  factory TaskUserGroup.fromJson(Map<String, dynamic> json, String id) {
    return TaskUserGroup(
      id: id,
      creator: json['creator'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      uids: List<String>.from(json['uids'] ?? []),
      inviteUids: List<String>.from(json['inviteUids'] ?? []),
    );
  }

  /// Convert the task object to the json.
  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'uids': uids,
      'inviteUids': inviteUids,
    };
  }

  /// convert TaskUserGroup to string
  @override
  String toString() {
    return toJson().toString();
  }

  /// Get TaskUserGroup
  static Future<TaskUserGroup?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return TaskUserGroup.fromSnapshot(snapshot);
  }

  /// Create new TaskUserGroup
  static Future<DocumentReference> create({
    required String title,
    String description = '',
  }) async {
    final ref = await col.add({
      'creator': TaskService.instance.currentUser!.uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'uids': [],
      'inviteUids': [],
    });
    return ref;
  }

  /// Update TaskUserGroup information
  Future<void> update({
    required String title,
    required String description,
  }) async {
    await ref.update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> inviteUid(String uid) async {
    await ref.update({
      'inviteUids': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> acceptInvite() {
    return ref.update({
      'uids': FieldValue.arrayUnion(inviteUids),
      'inviteUids': FieldValue.arrayRemove(inviteUids),
    });
  }

  Future<void> rejectInvite() {
    return ref.update({
      'inviteUids': FieldValue.arrayRemove(inviteUids),
    });
  }

  Future<void> delete() {
    return ref.delete();
  }
}
