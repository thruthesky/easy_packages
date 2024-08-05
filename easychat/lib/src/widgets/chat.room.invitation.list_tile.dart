import 'package:cached_network_image/cached_network_image.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomInvitationListTile extends StatefulWidget {
  const ChatRoomInvitationListTile({
    super.key,
    required this.room,
    this.afterAccept,
    this.afterReject,
  });

  final ChatRoom room;
  final Function(ChatRoom room, User? user)? afterAccept;
  final Function(ChatRoom room, User? user)? afterReject;

  @override
  State<ChatRoomInvitationListTile> createState() =>
      _ChatRoomInvitationListTileState();
}

class _ChatRoomInvitationListTileState
    extends State<ChatRoomInvitationListTile> {
  ChatRoom get room => widget.room;

  User? user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: room.group
          ? Container(
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
            )
          : UserDoc.sync(
              uid: getOtherUserUidFromRoomId(room.id)!,
              builder: (user) {
                this.user = user;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  width: 48,
                  height: 48,
                  clipBehavior: Clip.hardEdge,
                  child: user == null
                      ? const Icon(Icons.person)
                      : UserAvatar(user: user),
                );
              },
            ),
      title: room.group
          ? Text(
              room.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : UserDoc.sync(
              uid: getOtherUserUidFromRoomId(room.id)!,
              builder: (user) => Text(
                user?.displayName ?? "...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      subtitle: room.group
          ? Text(
              room.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : UserDoc.sync(
              uid: getOtherUserUidFromRoomId(room.id)!,
              builder: (user) => Text(
                user?.stateMessage ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              await widget.room.acceptInvitation();
              if (widget.afterAccept != null) {
                return widget.afterAccept?.call(room, user);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            child: const Text("Accept"),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () async {
              await widget.room.rejectInvitation();
              if (widget.afterReject != null) {
                return widget.afterReject!(room, user);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }
}
