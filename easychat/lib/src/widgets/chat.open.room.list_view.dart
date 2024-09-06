import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Open chat room list view
class ChatOpenRoomListView extends StatelessWidget {
  const ChatOpenRoomListView({
    super.key,
    this.itemBuilder,
    this.emptyBuilder,
    this.separatorBuilder,
  });

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return ChatJoinListTile(
          room: room,
        );
      },
    );
  }
}
