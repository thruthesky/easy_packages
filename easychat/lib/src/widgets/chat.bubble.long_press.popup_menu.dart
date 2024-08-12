import 'package:easy_locale/easy_locale.dart';
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
    reply: 'reply',
    delete: 'delete',
    edit: 'edit',
  );

  List<PopupMenuItem<String>> get menuItems => [
        if (ChatService.instance.replyEnabled == false)
          PopupMenuItem<String>(
            value: items.reply,
            height: 40,
            child: Text(items.reply.t),
          ),
        if (message.uid == myUid && message.deleted == false) ...[
          PopupMenuItem<String>(
            value: items.edit,
            height: 40,
            child: Text(items.edit.t),
          ),
          PopupMenuItem<String>(
            value: items.delete,
            height: 40,
            child: Text(items.delete.t),
          ),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: menuItems.isNotEmpty
          ? (details) async {
              final value = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  0,
                ),
                items: menuItems,
              );

              if (value != null) {
                if (value == items.reply) {
                  // room.replyTo(message);
                  if (context.mounted) {
                    ChatService.instance.reply.value = message;
                  }
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
          : null,
      child: child,
    );
  }
}
