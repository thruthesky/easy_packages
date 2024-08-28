import 'package:cloud_firestore/cloud_firestore.dart';

/// Chat room user field
///
/// Chat room user field is not a list. It's a map. Refere README.md for more
/// information.
class ChatRoomUser {
  // Field Names =========================
  static const field = (
    // Single Order is the single order that is affected by read
    singleOrder: 'sO',
    // Single Time Order is the single order that is only determined when the message was sent
    singleTimeOrder: 'sTO',
    // Group Order is the group order that is affected by read
    groupOrder: 'gO',
    // Group Time Order is the group order that is only determined when the message was sent
    groupTimeOrder: 'gTO',
    // Order is the order that is affected by read wheter it is single or group
    order: 'o',
    // Time Order is the order that is only determined when the message was sent
    timeOrder: 'tO',
    // New Message Counter is the number of new message
    newMessageCounter: 'nMC',
  );

  // Fields ==============================
  // Ordering is based on DateTime because we
  // have to use Server Time
  // to order it consistently.
  final DateTime? singleOrder;
  final DateTime? singleTimeOrder;
  final DateTime? groupOrder;
  final DateTime? groupTimeOrder;
  final DateTime? order;
  final DateTime? timeOrder;
  final int? newMessageCounter;

  ChatRoomUser({
    this.singleOrder,
    this.singleTimeOrder,
    this.groupOrder,
    this.groupTimeOrder,
    this.order,
    this.timeOrder,
    this.newMessageCounter,
  });

  factory ChatRoomUser.fromJson({
    required Map<String, dynamic> json,
  }) {
    return ChatRoomUser(
      singleOrder: json[field.singleOrder] is Timestamp
          ? (json[field.singleOrder] as Timestamp).toDate()
          : null,
      singleTimeOrder: json[field.singleTimeOrder] is Timestamp
          ? (json[field.singleTimeOrder] as Timestamp).toDate()
          : null,
      groupOrder: json[field.groupOrder] is Timestamp
          ? (json[field.groupOrder] as Timestamp).toDate()
          : null,
      groupTimeOrder: json[field.groupTimeOrder] is Timestamp
          ? (json[field.groupTimeOrder] as Timestamp).toDate()
          : null,
      order: json[field.order] is Timestamp
          ? (json[field.order] as Timestamp).toDate()
          : null,
      timeOrder: json[field.timeOrder] is Timestamp
          ? (json[field.timeOrder] as Timestamp).toDate()
          : null,
      newMessageCounter: json[field.newMessageCounter],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      field.singleOrder: singleOrder,
      field.singleTimeOrder: singleTimeOrder,
      field.groupOrder: groupOrder,
      field.groupTimeOrder: groupTimeOrder,
      field.order: order,
      field.timeOrder: timeOrder,
      field.newMessageCounter: newMessageCounter,
    };
  }

  @override
  String toString() {
    return 'ChatRoomUser({${toJson()}})';
  }
}
