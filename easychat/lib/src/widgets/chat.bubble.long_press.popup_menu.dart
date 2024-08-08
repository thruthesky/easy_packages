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
    edit: 'Edit',
  );

  List<PopupMenuItem<String>> get menuItems => [
        if (room.replyValueNotifier != null && message.deleted == false)
          PopupMenuItem<String>(
            value: items.reply,
            height: 40,
            child: Text(items.reply),
          ),
        if (message.uid == myUid && message.deleted == false) ...[
          PopupMenuItem<String>(
            value: items.edit,
            height: 40,
            child: Text(items.edit),
          ),
          PopupMenuItem<String>(
            value: items.delete,
            height: 40,
            child: Text(items.delete),
          ),
        ],
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
      } else if (value == items.edit) {
        if (!context.mounted) return;
        await ChatService.instance.editMessage(
          context,
          message: message,
          room: room,
        );
      } else if (value == items.delete) {
        ChatService.instance.deleteMessage(message);
      }
    }
  }
}
