import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';

class TaskUserGroup {
  static CollectionReference get col =>
      FirebaseFirestore.instance.collection('task-user-group');

  DocumentReference get ref => col.doc(id);

  TaskUserGroup({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
    required this.invitedUsers,
    required this.rejectedUsers,
  });

  /// [id] is the group id
  final String id;

  /// [uid] is the uid of the user who created this group
  final String uid;

  /// [title] is the group title
  final String title;

  /// [description] is the group description
  final String description;

  /// [createdAt] is the date and time when the group is created
  final DateTime createdAt;

  /// [updatedAt] is the date and time when the group is updated
  final DateTime updatedAt;

  /// [users] is the uid of the users accepted the invite
  final List<String> users;

  /// [invitedUsers] is the uid of the user that has pending invite
  final List<String> invitedUsers;

  /// [rejectedUsers] is the uid who rejected the group invite
  final List<String> rejectedUsers;

  /// Get the task object from the snapshot.
  factory TaskUserGroup.fromSnapshot(DocumentSnapshot snapshot) {
    return TaskUserGroup.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  /// Get the task object from the json.
  factory TaskUserGroup.fromJson(Map<String, dynamic> json, String id) {
    return TaskUserGroup(
      id: id,
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      users: List<String>.from(json['users'] ?? []),
      invitedUsers: List<String>.from(json['invitedUsers'] ?? []),
      rejectedUsers: List<String>.from(json['rejectedUsers'] ?? []),
    );
  }

  /// Convert the task object to the json.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'users': users,
      'invitedUsers': invitedUsers,
      'rejectedUsers': rejectedUsers,
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
      'uid': TaskService.instance.currentUser!.uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'users': [],
      'invitedUsers': [],
      'rejectedUsers': [],
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

  Future<void> inviteUser(String uid) async {
    await ref.update({
      'invitedUsers': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> acceptInvite() {
    return ref.update({
      'users': FieldValue.arrayUnion([TaskService.instance.currentUser!.uid]),
      'invitedUsers':
          FieldValue.arrayRemove([TaskService.instance.currentUser!.uid]),
    });
  }

  Future<void> rejectInvite() {
    return ref.update({
      'invitedUsers':
          FieldValue.arrayRemove([TaskService.instance.currentUser!.uid]),
      'rejectedUsers':
          FieldValue.arrayUnion([TaskService.instance.currentUser!.uid]),
    });
  }

  Future<void> delete() {
    return ref.delete();
  }
}
