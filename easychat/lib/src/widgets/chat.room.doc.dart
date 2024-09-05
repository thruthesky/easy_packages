import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

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
      onLoading: onLoading,
    );
  }
}
