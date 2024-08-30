import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_user_group/src/user_group.service.dart';

class UserGroup {
  static CollectionReference get col => UserGroupService.instance.col;

  DocumentReference get ref => col.doc(id);

  UserGroup({
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
  factory UserGroup.fromSnapshot(DocumentSnapshot snapshot) {
    return UserGroup.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  /// Get the task object from the json.
  factory UserGroup.fromJson(Map<String, dynamic> json, String id) {
    return UserGroup(
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

  /// convert UserGroup to string
  @override
  String toString() {
    return toJson().toString();
  }

  /// Get UserGroup
  static Future<UserGroup?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return UserGroup.fromSnapshot(snapshot);
  }

  /// Create new UserGroup
  static Future<DocumentReference> create({
    required String title,
    String description = '',
  }) async {
    final ref = await col.add({
      'uid': UserGroupService.instance.currentUser!.uid,
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

  /// Update UserGroup information
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
      'users':
          FieldValue.arrayUnion([UserGroupService.instance.currentUser!.uid]),
      'invitedUsers':
          FieldValue.arrayRemove([UserGroupService.instance.currentUser!.uid]),
    });
  }

  Future<void> rejectInvite() {
    return ref.update({
      'invitedUsers':
          FieldValue.arrayRemove([UserGroupService.instance.currentUser!.uid]),
      'rejectedUsers':
          FieldValue.arrayUnion([UserGroupService.instance.currentUser!.uid]),
    });
  }

  Future<void> delete() {
    return ref.delete();
  }
}
