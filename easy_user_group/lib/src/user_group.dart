import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_user_group/src/user_group.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserGroup {
  static CollectionReference get col => UserGroupService.instance.col;
  static User? get currentUser => FirebaseAuth.instance.currentUser;

  DocumentReference get ref => col.doc(id);

  UserGroup({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
    required this.pendingUsers,
    required this.declinedUsers,
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

  /// [pendingUsers] is the uid of the user that has pending invite
  final List<String> pendingUsers;

  /// [declinedUsers] is the uid who rejected the group invite
  final List<String> declinedUsers;

  /// Get the user group object from the snapshot.
  factory UserGroup.fromSnapshot(DocumentSnapshot snapshot) {
    return UserGroup.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  /// Get the user group object from the json.
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
      pendingUsers: List<String>.from(json['pendingUsers'] ?? []),
      declinedUsers: List<String>.from(json['declinedUsers'] ?? []),
    );
  }

  /// Convert the user group object to the json.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'users': users,
      'pendingUsers': pendingUsers,
      'declinedUsers': declinedUsers,
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
      'uid': currentUser!.uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'users': [currentUser!.uid],
      'pendingUsers': [],
      'declinedUsers': [],
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
      'pendingUsers': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> acceptInvite() {
    return ref.update({
      'users': FieldValue.arrayUnion([currentUser!.uid]),
      'pendingUsers': FieldValue.arrayRemove([currentUser!.uid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectInvite() {
    return ref.update({
      'pendingUsers': FieldValue.arrayRemove([currentUser!.uid]),
      'declinedUsers': FieldValue.arrayUnion([currentUser!.uid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> leave() {
    return ref.update({
      'users': FieldValue.arrayRemove([currentUser!.uid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete() {
    return ref.delete();
  }
}
