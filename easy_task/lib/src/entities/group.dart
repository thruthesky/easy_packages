import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class Group {
  static final CollectionReference col = TaskService.instance.groupCol;
  DocumentReference get ref => col.doc(id);

  String id;
  String name;
  List<String> users;
  List<String> moderators;
  List<String> invitedUsers;

  /// [rejectedUsers] is the list of
  /// users' uids who rejecte/declined the
  /// invitation
  List<String> rejectedUsers;
  DateTime createdAt;
  DateTime updatedAt;

  Group({
    required this.id,
    required this.name,
    required this.users,
    required this.moderators,
    required this.invitedUsers,
    required this.rejectedUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp? createdAt = json['createdAt'];
    final Timestamp? updatedAt = json['updatedAt'];
    return Group(
      id: id,
      name: json['name'] ?? '',
      users: json['users'] ?? [],
      moderators: json['moderators'] ?? [],
      invitedUsers: json['invitedUsers'] ?? [],
      rejectedUsers: json['rejectedUsers'] ?? [],
      createdAt: createdAt?.toDate() ?? DateTime.now(),
      updatedAt: updatedAt?.toDate() ?? DateTime.now(),
    );
  }

  factory Group.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return Group.fromJson(json, snapshot.id);
  }

  static Future<DocumentReference> create({
    required String name,
  }) async {
    final ref = await col.add({
      'name': name,
      'users': [],
      'moderators': [myUid!],
      'invitedUsers': [],
      'rejectedUsers': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref;
  }

  /// Get a Group by its id
  static Future<Group?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) return null;
    return Group.fromSnapshot(snapshot);
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
  Future<void> invite(String uid) async {}

  Future<void> delete() async {
    await ref.delete();
  }
}
