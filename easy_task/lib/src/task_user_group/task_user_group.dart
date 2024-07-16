import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class TaskUserGroup {
  static final CollectionReference col = TaskService.instance.userGroupCol;
  DocumentReference get ref => col.doc(id);

  final String id;

  /// [name] is the name of the group
  final String name;

  /// [users] is the list of
  /// users' uids who are members
  final List<String> users;

  /// [moderatorUsers] is the list of
  /// users' uids who are moderators
  final List<String> moderatorUsers;

  /// [invitedUsers] is the list of
  /// users' uids who invited the group
  final List<String> invitedUsers;

  /// [rejectedUsers] is the list of
  /// users' uids who rejecte/declined the
  /// invitation
  final List<String> rejectedUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskUserGroup({
    required this.id,
    required this.name,
    required this.users,
    required this.moderatorUsers,
    required this.invitedUsers,
    required this.rejectedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskUserGroup.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp? createdAt = json['createdAt'];
    final Timestamp? updatedAt = json['updatedAt'];
    return TaskUserGroup(
      id: id,
      name: json['name'] ?? '',
      users: List<String>.from(json['users'] ?? []),
      moderatorUsers: List<String>.from(json['moderatorUsers'] ?? []),
      invitedUsers: List<String>.from(json['invitedUsers'] ?? []),
      rejectedUsers: List<String>.from(json['rejectedUsers'] ?? []),
      createdAt: createdAt?.toDate() ?? DateTime.now(),
      updatedAt: updatedAt?.toDate() ?? DateTime.now(),
    );
  }

  factory TaskUserGroup.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return TaskUserGroup.fromJson(json, snapshot.id);
  }

  static Future<DocumentReference> create({
    required String name,
  }) async {
    final ref = await col.add({
      'name': name,
      'users': [],
      'moderatorUsers': [myUid!],
      'invitedUsers': [],
      'rejectedUsers': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref;
  }

  /// Get a TaskUserGroup by its id
  static Future<TaskUserGroup?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) return null;
    return TaskUserGroup.fromSnapshot(snapshot);
  }

  Future<void> update({
    String? name,
  }) async {
    final updateData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (name != null) updateData['name'] = name;
    await ref.update(updateData);
  }

  Future<void> addUser(String uid) async {
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> removeUser(String uid) async {
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'members': FieldValue.arrayRemove([uid]),
    });
  }

  /// Invites the user to join the group
  Future<void> inviteUsers(List<String> uid) async {
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'invitedUsers': FieldValue.arrayUnion(uid),
    });
  }

  /// Rejects the invitation
  ///
  /// Current user rejects the group invitation by
  /// adding his/her uid in `rejectedUsers`
  Future<void> reject() async {
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'invitedUsers': FieldValue.arrayRemove([myUid!]),
      'rejectedUsers': FieldValue.arrayUnion([myUid!]),
    });
  }

  /// Accepts the invitation
  ///
  /// Current user accepts the group invitation by
  /// adding his/her uid in `users`.
  Future<void> accept() async {
    if (!invitedUsers.contains(myUid!)) {
      throw 'You are not invited to join this group';
    }
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'invitedUsers': FieldValue.arrayRemove([myUid!]),
      'rejectedUsers': FieldValue.arrayRemove([myUid!]),
      'users': FieldValue.arrayUnion([myUid!])
    });
  }

  /// Deletes the group
  Future<void> delete() async {
    await ref.delete();
  }
}
