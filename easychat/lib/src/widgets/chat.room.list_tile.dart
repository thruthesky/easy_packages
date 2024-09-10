import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Display chat joins in list tile
class ChatRoomListTile extends StatelessWidget {
  const ChatRoomListTile({
    super.key,
    required this.join,
  });

  final ChatJoin join;

  @override
  Widget build(BuildContext context) {
    final trailing = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChatNewMessageCounter(roomId: join.roomId),
        Text((join.lastMessageAt).short),
      ],
    );
    if (join.group) {
      return ListTile(
        minTileHeight: 72,
        leading: leading(context: context),
        title: Text(
          join.name.notEmpty ? join.name! : "Group Chat",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle(context),
        trailing: trailing,
        onTap: () =>
            ChatService.instance.showChatRoomScreen(context, join: join),
      );
    }
    return UserBlocked(
      otherUid: getOtherUserUidFromRoomId(join.roomId)!,
      builder: (blocked) {
        if (blocked) {
          dog("Blocked: ${join.roomId}");
          // Showing shrink is no good because
          // we are using separator
          // return const SizedBox.shrink();
          return ListTile(
            minTileHeight: 72,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: context.onSurface.withAlpha(50),
              ),
              width: 48,
              height: 48,
              child: Icon(
                Icons.block,
                color: context.onSurface.withAlpha(50),
              ),
            ),
            title: Text(
              "blocked user".t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              ),
            ),
            subtitle: Text(
              "this message is comming from a blocked user".t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              ),
            ),
            onTap: () async {
              final confirmLeave = await confirm(
                context: context,
                title: const Text("Leave Chat Confirmation"),
                message: const Text(
                  "This is comming from a blocked user. Do you want to leave the chat room?",
                ),
              );
              if (confirmLeave != true) return;
              final room = await ChatRoom.get(join.roomId);
              if (room == null) return;
              await ChatService.instance.leave(room);
            },
          );
        }
        return ListTile(
          minTileHeight: 72,
          leading: join.photoUrl.isEmpty
              ? CircleAvatar(
                  child: Text(getOtherUserUidFromRoomId(join.roomId)!
                      .characters
                      .first
                      .toUpperCase()),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: join.photoUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          title: Text(roomTitle(null, null, join)),
          subtitle: subtitle(context),
          trailing: trailing,
          onTap: () =>
              ChatService.instance.showChatRoomScreen(context, join: join),
        );
      },
    );
  }

  leading({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      width: 48,
      height: 48,
      clipBehavior: Clip.hardEdge,
      child: join.iconUrl.notEmpty
          ? CachedNetworkImage(
              imageUrl: join.iconUrl!,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.people,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
    );
  }

  /// Returns a subtitle widget for the chat room list tile in chat room list view.
  ///
  /// It gets the last message from the chat/message/<room-id>.
  Widget? subtitle(BuildContext context) {
    // Is a protocol message?
    if (join.lastProtocol.notEmpty) {
      String text = join.lastProtocol!.t;
      if (join.single) {
        if ([ChatProtocol.join, ChatProtocol.left]
            .contains(join.lastProtocol)) {
          // Added one extra code for getting the correct displayName, (only for single chat).
          // In protocol, we are using join.displayName field to put the displayName of protocol's sender
          // However, in single chat, we are also using join.displayName for the other user.
          // This will help show the correct display name in single chat;
          // Group chats are not affected because they are not using displayName field.
          // Just make sure that join.lastMessageUid is always correctly provided.
          final displayName =
              join.lastMessageUid == myUid ? my.displayName : join.displayName;
          text = join.lastProtocol!.tr(args: {'displayName': displayName});
        }
      } else {
        // if (join.group)
        // For group we simply, use join.displayName
        // In case protocol translation doesn't have "{displayName}", it is fine,
        // since it wont alter any text anyway if there is no "{displayName}".
        text = join.lastProtocol!.tr(args: {'displayName': join.displayName});
      }
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
        ),
      );
    } else if (join.lastMessageDeleted == true) {
      return Text(
        "last message was deleted".t,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
        ),
      );
    } else if (!join.lastText.isNullOrEmpty &&
        !join.lastPhotoUrl.isNullOrEmpty) {
      return Row(
        children: [
          Icon(
            Icons.photo,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            size: 16,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              join.lastText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else if (!join.lastText.isNullOrEmpty) {
      return Text(
        join.lastText!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (!join.lastPhotoUrl.isNullOrEmpty) {
      return Row(
        children: [
          Icon(
            Icons.photo,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            "[${'photo'.t}]",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
            ),
          ),
        ],
      );
    } else {
      dog("Something is wrong because the code should never go here. Check chat.room.list_tile.dart");
      // This is mostly an error
      return null;
    }
  }
}
