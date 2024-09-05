import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Display chat room list tile
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
          join.name.trim().isNotEmpty ? join.name : "Group Chat",
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
          return const SizedBox.shrink();
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
                      // border: border,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: join.photoUrl,
                    ),
                  ),
                ),
          title: Text(join.name.or('...')),
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
      child: join.iconUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: join.iconUrl,
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
    // TODO: if the user is not in the chat room, (may be in invited list), does it need to show the description?
    // if (!room.userUids.contains(myUid)) {
    //   if (room.description.trim().isEmpty) {
    //     return null;
    //   }
    //   return Text(
    //     room.description,
    //     maxLines: 1,
    //     overflow: TextOverflow.ellipsis,
    //     style: TextStyle(
    //       color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
    //     ),
    //   );
    // }
    return StreamBuilder<DatabaseEvent>(
      stream:
          ChatService.instance.messageRef(join.roomId).limitToLast(1).onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("...");
        }
        // Maybe we can cache here to prevent the sudden "..." when the order is
        // being changed when there is new user.
        if (snapshot.data?.snapshot.value == null) {
          if (join.single == true) {
            return Text(
              'single chat no message, no invitations'.t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(110),
              ),
            );
          } else {
            return Text(
              'no message yet'.t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(110),
              ),
            );
          }
        }
        final firstRecord =
            Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map)
                .entries
                .first;
        final messageJson = Map<String, dynamic>.from(firstRecord.value as Map);
        final lastMessage = ChatMessage.fromJson(messageJson, firstRecord.key);

        if (lastMessage.deleted) {
          return Text(
            'last message was deleted'.t,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(110),
            ),
          );
        }
        if (UserService.instance.blockChanges.value
            .containsKey(lastMessage.uid)) {
          return const Text("...");
        }
        return Row(
          children: [
            if (!lastMessage.url.isNullOrEmpty) ...[
              const Icon(Icons.photo, size: 16),
              const SizedBox(width: 4),
            ],
            if (!lastMessage.text.isNullOrEmpty)
              Flexible(
                child: Text(
                  lastMessage.text!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else if (!lastMessage.url.isNullOrEmpty)
              Flexible(
                child: Text(
                  "[${'photo'.t}]",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(110),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
