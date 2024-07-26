import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomUser {
  // Field Names =========================
  static const field = (
    singleOrder: 'sO',
    groupOrder: 'gO',
    order: 'o',
    newMessageCounter: 'nMC',
  );

  // Fields ==============================
  // Ordering is based on DateTime because we
  // have to use Server Time
  // to order it consistently.
  final DateTime? singleOrder;
  final DateTime? groupOrder;
  final DateTime? order;
  final int? newMessageCounter;

  ChatRoomUser({
    this.singleOrder,
    this.groupOrder,
    this.order,
    this.newMessageCounter,
  });

  factory ChatRoomUser.fromJson({
    required Map<String, dynamic> json,
  }) {
    return ChatRoomUser(
      singleOrder: json[field.singleOrder] is Timestamp
          ? (json[field.singleOrder] as Timestamp).toDate()
          : null,
      groupOrder: json[field.groupOrder] is Timestamp
          ? (json[field.groupOrder] as Timestamp).toDate()
          : null,
      order: json[field.order] is Timestamp
          ? (json[field.order] as Timestamp).toDate()
          : null,
      newMessageCounter: json[field.newMessageCounter],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      field.singleOrder: singleOrder,
      field.groupOrder: groupOrder,
      field.order: order,
      field.newMessageCounter: newMessageCounter,
    };
  }

  @override
  String toString() {
    return 'ChatRoomUser({${toJson()}})';
  }
}
