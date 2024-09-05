import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomDoc extends StatelessWidget {
  const ChatRoomDoc({
    super.key,
    // Review how can we better handle this
    this.roomId,
    this.room,
    required this.builder,
    this.onLoading,
  }) : assert(roomId != null || room != null);

  final String? roomId;
  final ChatRoom? room;
  final Widget Function(ChatRoom room) builder;
  final Widget? onLoading;

  @override
  Widget build(BuildContext context) {
    final ref = ChatService.instance.roomRef(roomId!);
    return Value(
      ref: ref,
      builder: (v, r) {
        return builder(
          ChatRoom.fromJson(
            Map<String, dynamic>.from(v),
            ref.key!,
          ),
        );
      },
      onLoading: room == null ? onLoading : builder(room!),
    );
  }
}
