import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Chat room data cache
///
/// Why:
/// - To reduce the flickering.
final chatRoomDataCache = {};

class ChatRoomDoc extends StatelessWidget {
  const ChatRoomDoc({
    super.key,
    required this.roomId,
    required this.builder,
    this.onLoading,
  });

  final String roomId;

  final Widget Function(ChatRoom room) builder;
  final Widget? onLoading;

  @override
  Widget build(BuildContext context) {
    final ref = ChatService.instance.roomRef(roomId);

    /// Without initialData, it will flickering when chat room data is loaded on a list
    return Value(
      ref: ref,
      initialData: chatRoomDataCache[roomId],
      builder: (v, r) {
        chatRoomDataCache[roomId] = Map<String, dynamic>.from(v as Map);
        final room = ChatRoom.fromJson(
          Map<String, dynamic>.from(v),
          ref.key!,
        );
        return builder(
          room,
        );
      },
      onLoading: onLoading,
    );
  }
}
