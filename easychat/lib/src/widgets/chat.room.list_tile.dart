import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomListTile extends StatelessWidget {
  const ChatRoomListTile({
    super.key,
    required this.room,
    this.onTap,
  });

  final ChatRoom room;
  final Function(ChatRoom room)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: room.single
          ? UserDoc.sync(
              uid: getOtherUserUidFromRoomId(room.id)!,
              builder: (user) {
                if (user == null) return const SizedBox.shrink();
                return UserAvatar(user: user);
              },
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.tertiaryContainer,
              ),
              width: 48,
              height: 48,
              child: const Icon(Icons.people)),
      title: room.single
          ? UserDoc.sync(
              uid: getOtherUserUidFromRoomId(room.id)!,
              builder: (user) {
                if (user == null) return Text(room.id);
                return Text(user.displayName.trim().isNotEmpty
                    ? user.displayName
                    : user.uid);
              },
            )
          : Text(room.name.trim().isNotEmpty ? room.name : room.id),
      subtitle:
          room.lastMessageText != null ? Text(room.lastMessageText!) : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text((room.lastMessageAt ?? room.updatedAt).short),
          if ((room.users[my.uid]?.newMessageCounter ?? 0) > 0)
            Badge(
              label: Text("${room.users[my.uid]!.newMessageCounter}"),
            ),
        ],
      ),
      onTap: () => onTap != null
          ? onTap!.call(room)
          : ChatService.instance.showChatRoomScreen(
              context,
              room: room,
            ),
    );
  }
}
