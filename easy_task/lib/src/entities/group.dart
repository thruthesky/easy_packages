import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';

class Group {
  static final CollectionReference col = TaskService.instance.groupCol;
  DocumentReference get ref => col.doc(id);

  String id;
  String name;
  List<String> members;
  String moderatorUid;
  DateTime createdAt;
  DateTime updatedAt;

  Group({
    required this.id,
    required this.name,
    this.members = const [],
    required this.moderatorUid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp? createdAt = json['createdAt'];
    final Timestamp? updatedAt = json['updatedAt'];
    return Group(
      id: id,
      name: json['name'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      moderatorUid: json['moderatorUid'],
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
      'members': [],
      'moderatorUid': myUid!,
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

  Future<void> addMember(String uid) async {
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> removeMember(String uid) async {
    await ref.update({
      'updatedAt': FieldValue.serverTimestamp(),
      'members': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> delete() async {
    await ref.delete();
  }
}
