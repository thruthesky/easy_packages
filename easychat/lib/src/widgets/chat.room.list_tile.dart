import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomListTile extends StatelessWidget {
  const ChatRoomListTile({
    super.key,
    required this.room,
    this.onTap,
  });

  final ChatRoom room;
  final Function(BuildContext context, ChatRoom room, User? user)? onTap;

  @override
  Widget build(BuildContext context) {
    if (room.group) {
      return ListTile(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          width: 48,
          height: 48,
          clipBehavior: Clip.hardEdge,
          child: room.iconUrl != null && room.iconUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: room.iconUrl!,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.people),
        ),
        title: Text(room.name.trim().isNotEmpty ? room.name : "..."),
        subtitle: subtitle,
        trailing: trailing,
        onTap: () => onTapTile(context, room, null),
      );
    }
    return UserDoc.sync(
      uid: getOtherUserUidFromRoomId(room.id)!,
      builder: (user) {
        return ListTile(
          leading: user == null ? null : UserAvatar(user: user),
          title: user == null
              ? Text(room.id)
              : Text(user.displayName.trim().isNotEmpty
                  ? user.displayName
                  : '...'),
          subtitle: subtitle,
          trailing: trailing,
          onTap: () => onTapTile(context, room, user),
        );
      },
    );
  }

  Widget? get subtitle => room.lastMessageDeleted == true
      ? Text(
          'last message was deleted'.t,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      : room.lastMessageText != null
          ? Text(
              room.lastMessageText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null;

  Widget get trailing {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text((room.lastMessageAt ?? room.updatedAt).short),
        if ((room.users[myUid]?.newMessageCounter ?? 0) > 0)
          Badge(
            label: Text("${room.users[myUid!]!.newMessageCounter}"),
          ),
      ],
    );
  }

  onTapTile(BuildContext context, ChatRoom room, User? user) {
    onTap != null
        ? onTap!.call(context, room, user)
        : ChatService.instance.showChatRoomScreen(
            context,
            room: room,
            user: user,
          );
  }
}
