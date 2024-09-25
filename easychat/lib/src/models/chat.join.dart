import 'package:firebase_database/firebase_database.dart';

import '../chat.defines.dart' as f;

class ChatJoin {
  final String roomId;
  final int joinedAt;
  final int? singleOrder;
  final int? groupOrder;
  final int? openOrder;
  final int order;
  final String? lastMessageUid;
  final DateTime? lastMessageAt;
  final bool? lastMessageDeleted;
  final String? lastText;
  final String? lastUrl;
  final String? lastProtocol;

  final int unreadMessageCount;

  final String? name;
  final String? iconUrl;
  final String? displayName;
  final String? photoUrl;

  bool get group => groupOrder != null;
  bool get single => singleOrder != null;
  bool get open => openOrder != null;

  ChatJoin({
    required this.roomId,
    required this.joinedAt,
    required this.singleOrder,
    required this.groupOrder,
    required this.openOrder,
    required this.order,
    required this.lastMessageUid,
    required this.lastMessageAt,
    required this.lastMessageDeleted,
    required this.lastText,
    required this.lastUrl,
    required this.lastProtocol,
    this.unreadMessageCount = 0,
    this.name,
    this.iconUrl,
    this.displayName,
    this.photoUrl,
  });

  factory ChatJoin.fromSnapshot(DataSnapshot snapshot) {
    return ChatJoin.fromJson(snapshot.value as Map, snapshot.key!);
  }

  factory ChatJoin.fromJson(Map<dynamic, dynamic> json, String roomId) {
    return ChatJoin(
      roomId: roomId,
      joinedAt: json[f.joinedAt] ?? DateTime.now().millisecondsSinceEpoch,
      singleOrder: json[f.singleOrder],
      groupOrder: json[f.groupOrder],
      openOrder: json[f.openOrder],
      order: json[f.order] ?? DateTime.now().millisecondsSinceEpoch,
      lastMessageUid: json[f.lastMessageUid],
      lastMessageAt: DateTime.fromMillisecondsSinceEpoch(json[f.lastMessageAt] ?? 0),
      lastMessageDeleted: json[f.lastMessageDeleted],
      lastUrl: json[f.lastUrl],
      lastText: json[f.lastText],
      lastProtocol: json[f.lastProtocol],
      unreadMessageCount: json[f.unreadMessageCount] ?? 0,
      name: json[f.name],
      iconUrl: json[f.iconUrl],
      displayName: json[f.displayName],
      photoUrl: json[f.photoUrl],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      f.joinedAt: joinedAt,
      f.singleOrder: singleOrder,
      f.groupOrder: groupOrder,
      f.openOrder: openOrder,
      f.order: order,
      f.lastMessageUid: lastMessageUid,
      f.lastMessageAt: lastMessageAt,
      f.lastMessageDeleted: lastMessageDeleted,
      f.lastText: lastText,
      f.lastUrl: lastUrl,
      f.lastProtocol: lastProtocol,
      f.unreadMessageCount: unreadMessageCount,
      'name': name,
      'iconUrl': iconUrl,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
