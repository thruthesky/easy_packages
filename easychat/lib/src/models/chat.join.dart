import 'package:firebase_database/firebase_database.dart';

import '../chat.defines.dart' as f;

class ChatJoin {
  final String roomId;
  final int joinedAt;
  final int? singleOrder;
  final int? groupOrder;
  final int? openOrder;
  final int order;
  final String lastMessageBy;
  final DateTime lastMessageAt;
  final String? lastText;
  final String? lastPhotoUrl;

  final String name;
  final String iconUrl;
  final String displayName;
  final String photoUrl;

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
    required this.lastMessageBy,
    required this.lastMessageAt,
    required this.lastText,
    required this.lastPhotoUrl,
    this.name = '',
    this.iconUrl = '',
    this.displayName = '',
    this.photoUrl = '',
  });

  factory ChatJoin.fromSnapshot(DataSnapshot snapshot) {
    return ChatJoin.fromJson(snapshot.value as Map, snapshot.key!);
  }

  factory ChatJoin.fromJson(Map<dynamic, dynamic> json, String roomId) {
    return ChatJoin(
      roomId: roomId,
      joinedAt: json[f.joinedAt],
      singleOrder: json[f.singleOrder],
      groupOrder: json[f.groupOrder],
      openOrder: json[f.openOrder],
      order: json[f.order],
      lastMessageBy: json[f.lastMessageBy],
      lastMessageAt:
          DateTime.fromMillisecondsSinceEpoch(json[f.lastMessageAt] ?? 0),
      lastPhotoUrl: json[f.lastPhotoUrl],
      lastText: json[f.lastText],
      name: json[f.name] ?? '',
      iconUrl: json[f.iconUrl] ?? '',
      displayName: json[f.displayName] ?? '',
      photoUrl: json[f.photoUrl] ?? '',
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
      f.lastMessageBy: lastMessageBy,
      f.lastMessageAt: lastMessageAt,
      'name': name,
      'iconUrl': iconUrl,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
