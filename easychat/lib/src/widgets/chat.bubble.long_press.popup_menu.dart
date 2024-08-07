import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubbleLongPressPopupMenu extends StatelessWidget {
  const ChatBubbleLongPressPopupMenu({
    super.key,
    required this.message,
    required this.room,
    required this.child,
  });

  final ChatMessage message;
  final ChatRoom room;
  final Widget child;

  static const items = (
    reply: 'Reply',
    delete: 'Delete',
  );

  List<PopupMenuItem<String>> get menuItems => [
        if (room.replyValueNotifier != null)
          PopupMenuItem<String>(
            value: items.reply,
            height: 40,
            child: Text(items.reply),
          ),
        if (message.uid == myUid)
          PopupMenuItem<String>(
            value: items.delete,
            height: 40,
            child: Text(items.delete),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: menuItems.isNotEmpty
          ? (details) {
              showPopupMenu(context, details.globalPosition);
            }
          : null,
      child: child,
    );
  }

  void showPopupMenu(BuildContext context, Offset offset) async {
    final value = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, 0),
      items: menuItems,
    );

    if (value != null) {
      if (value == items.reply) {
        room.replyTo(message);
      } else if (value == items.delete) {
        // Need to get here because room is not latest.
        // However, deleting happens occasionally and
        // wont cost much read counts.
        final latestRoom = await ChatRoom.get(room.id);
        await latestRoom!.mayDeleteLastMessage(message.id);
        await message.delete();
      }
    }
  }
}
