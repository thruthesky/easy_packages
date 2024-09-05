import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Display the number of new messages in the chat room.
///
/// This widget rebuild when the number of new messages changes.
class ChatNewMessageCounter extends StatelessWidget {
  const ChatNewMessageCounter({
    super.key,
    required this.roomId,
    this.builder,
  });

  final Widget Function(int newMessages)? builder;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: ChatService.instance.unreadMessageCountRef(roomId),
      builder: (value, ref) {
        final int count = value ?? 0;
        if (count == 0) {
          return const SizedBox.shrink();
        }
        return ChatService.instance.newMessageBuilder
                ?.call((value).toString()) ??
            builder?.call(count) ??
            Badge(
              label: Text(
                "$count",
              ),
            );
      },
    );
  }
}
