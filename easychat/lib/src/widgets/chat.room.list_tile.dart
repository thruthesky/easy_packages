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
        title: Text(
          room.name.trim().isNotEmpty ? room.name : "Group Chat",
        ),
        subtitle: subtitle,
        trailing: trailing,
        onTap: () => onTapTile(context, room, null),
      );
    }
    return UserBlocked(
      otherUid: getOtherUserUidFromRoomId(room.id)!,
      builder: (blocked) {
        if (blocked) {
          return const SizedBox.shrink();
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
      : Row(
          children: [
            if (room.lastMessageUrl != null &&
                room.lastMessageUrl!.isNotEmpty) ...[
              const Icon(Icons.photo, size: 16),
              const SizedBox(width: 4),
            ],
            if (room.lastMessageText != null &&
                room.lastMessageText!.isNotEmpty)
              Flexible(
                child: Text(
                  room.lastMessageText!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else if (room.lastMessageUrl != null &&
                room.lastMessageUrl!.isNotEmpty)
              Flexible(
                child: Text(
                  "[${'photo'.t}]",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Text(""),
          ],
        );

  Widget get trailing {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if ((room.users[myUid]?.newMessageCounter ?? 0) > 0)
          ChatService.instance.chatRoomNewMessageBuilder
                  ?.call(room.users[myUid]!.newMessageCounter ?? 0) ??
              Badge(
                label: Text(
                  "${room.users[myUid!]!.newMessageCounter}",
                ),
              ),
        Text((room.lastMessageAt ?? room.updatedAt).short),
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
