import 'package:cached_network_image/cached_network_image.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomInvitationListTile extends StatefulWidget {
  const ChatRoomInvitationListTile({
    super.key,
    required this.room,
    this.onAccept,
    this.onReject,
  });

  final ChatRoom room;
  final Function(ChatRoom room, User? user)? onAccept;
  final Function(ChatRoom room, User? user)? onReject;

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
              if (widget.onAccept != null) {
                // This widget onAccept must be called before
                // awaiting the acceptInvitation.
                // There is an issue in showGeneralDialog.
                // If we acceptInvite first, there is a
                // chance that this context is already unmounted,
                // or this widget maybe disposed.
                //
                // This is coming from flutter document:
                // The useRootNavigator argument is used to
                // determine whether to push the dialog to
                // the Navigator furthest from or nearest to
                // the given context. By default, useRootNavigator
                // is true and the dialog route created by this
                // method is pushed to the root navigator.
                // It can not be null.
                //
                // It might be the cause why it throws null error
                // on showGeneralDialog. (It doesn't have much info
                // about the error).
                widget.onAccept!(room, user);
              }
              await widget.room.acceptInvitation();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            child: const Text("Accept"),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () async {
              if (widget.onReject != null) {
                widget.onReject!(room, user);
              }
              await widget.room.rejectInvitation();
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
