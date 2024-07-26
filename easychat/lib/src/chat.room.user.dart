import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomUser {
  // Field Names =========================
  static const field = (
    singleOrder: 'sO',
    groupOrder: 'gO',
    newMessageCounter: 'nMC',
  );

  // Fields ==============================
  final String uid;
  // Ordering is based on DateTime because we
  // have to use Server Time
  // to order it consistently.
  final DateTime? singleOrder;
  final DateTime? groupOrder;
  final int? newMessageCounter;

  ChatRoomUser({
    required this.uid,
    this.singleOrder,
    this.groupOrder,
    this.newMessageCounter,
  });

  factory ChatRoomUser.fromJson({
    required Map<String, dynamic> json,
    required String uid,
  }) {
    return ChatRoomUser(
      uid: uid,
      singleOrder: json[field.singleOrder] is Timestamp
          ? (json[field.singleOrder] as Timestamp).toDate()
          : null,
      groupOrder: json[field.groupOrder] is Timestamp
          ? (json[field.groupOrder] as Timestamp).toDate()
          : null,
      newMessageCounter: json[field.newMessageCounter],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      field.singleOrder: singleOrder,
      field.groupOrder: groupOrder,
      field.newMessageCounter: newMessageCounter,
    };
  }

  MapEntry get toMapEntry => MapEntry(uid, toJson());

  @override
  String toString() {
    return 'ChatRoomUser($uid:{${toJson()}})';
  }
}
