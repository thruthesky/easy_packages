import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Display chat joins in list tile
class ChatJoinListTile extends StatelessWidget {
  const ChatJoinListTile({
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
    // Question: If the user is not in the chat room, (may be in invited list), does it need to show the description?
    // Answer: Chat Room List Tile was also used to show OPEN chat room as well. Since we changed the logic, we may need to
    //         provide a different widget to show the open room.
    // TODO: Move it somewhere else
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
    if (join.lastText == null) {
      return Text(
        'no message yet'.t,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(110),
        ),
      );
    }

    return Text(join.lastText!);
  }
}
