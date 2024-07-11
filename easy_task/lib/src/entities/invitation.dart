import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class Invitation {
  static final CollectionReference col = TaskService.instance.invitationCol;
  DocumentReference get ref => col.doc(id);

  String id;
  String uid;
  String invitedBy;
  String groupId;
  DateTime createdAt;

  Invitation({
    required this.id,
    required this.uid,
    required this.invitedBy,
    required this.groupId,
    required this.createdAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp? createdAt = json['createdAt'];
    return Invitation(
      id: id,
      uid: json['uid'],
      invitedBy: json['invitedBy'],
      groupId: json['groupId'],
      createdAt: createdAt == null ? DateTime.now() : createdAt.toDate(),
    );
  }

  factory Invitation.fromSnapshot(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    return Invitation.fromJson(json, snapshot.id);
  }

  /// To [create] means to invite user
  ///
  /// returns the DocumentReference of the created invitation
  static Future<DocumentReference> create({
    required String uid,
    required String groupId,
  }) async {
    final ref = await col.add({
      'uid': uid,
      'invitedBy': myUid!,
      'groupId': groupId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref;
  }

  /// Get an Invitation by its id
  static Future<Invitation?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) return null;
    return Invitation.fromSnapshot(snapshot);
  }

  /// Delete the invitation
  Future<void> delete() async {
    await ref.delete();
  }
}
