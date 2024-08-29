import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomInvitationListTile extends StatelessWidget {
  const ChatRoomInvitationListTile({
    super.key,
    required this.room,
    this.onAccept,
    this.onReject,
  });

  final ChatRoom room;
  final Function(ChatRoom room, User? user)? onAccept;
  final Function(ChatRoom room, User? user)? onReject;

  static const double _minTileHeight = 70;

  static const EdgeInsetsGeometry _contentPadding =
      EdgeInsets.symmetric(horizontal: 16);

  Future onTapAccept([User? user]) async {
    onAccept?.call(room, user);
    await room.acceptInvitation();
  }

  Future onTapReject([User? user]) async {
    onReject?.call(room, user);
    await room.rejectInvitation();
  }

  @override
  Widget build(BuildContext context) {
    if (room.single) {
      return UserDoc.sync(
        uid: getOtherUserUidFromRoomId(room.id)!,
        builder: (user) {
          return ListTile(
            minTileHeight: _minTileHeight,
            leading: GestureDetector(
              onTap: () => UserService.instance.showPublicProfileScreen(
                context,
                user: user!,
              ),
              child: Container(
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
              ),
            ),
            title: Text(
              user?.displayName ?? "...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle:
                user?.stateMessage != null && user!.stateMessage!.isNotEmpty
                    ? Text(
                        user.stateMessage ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
            trailing: ChatRoomInvitationListTileActions(
              onTapAccept: () => onTapAccept(user),
              onTapReject: () => onTapReject(user),
            ),
            contentPadding: _contentPadding,
          );
        },
      );
    }

    // else, it means it is a group chat
    return ListTile(
      minTileHeight: _minTileHeight,
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
            : Icon(
                Icons.people,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
      ),
      title: Text(
        room.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        room.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ChatRoomInvitationListTileActions(
        onTapAccept: onTapAccept,
        onTapReject: onTapReject,
      ),
      contentPadding: _contentPadding,
    );
  }
}

/// The actions for the ChatRoomInvitationListTile.
///
/// It contains two buttons: accept and reject.
///
/// Purpose:
/// - To display the progress (as disabled) while preventing the user from double clicking the same button.
class ChatRoomInvitationListTileActions extends StatefulWidget {
  const ChatRoomInvitationListTileActions({
    super.key,
    required this.onTapAccept,
    required this.onTapReject,
  });

  final void Function() onTapAccept;
  final void Function() onTapReject;

  @override
  State<ChatRoomInvitationListTileActions> createState() =>
      _ChatRoomInvitationListTileActionsState();
}

class _ChatRoomInvitationListTileActionsState
    extends State<ChatRoomInvitationListTileActions> {
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: inProgress
              ? null
              : () async {
                  if (inProgress) return;
                  setState(() => inProgress = true);
                  widget.onTapAccept();
                  setState(() => inProgress = false);
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
          ),
          child: Text("accept".t),
        ),
        const SizedBox(width: 4),
        ElevatedButton(
          onPressed: inProgress
              ? null
              : () async {
                  if (inProgress) return;
                  setState(() => inProgress = true);
                  widget.onTapReject();
                  setState(() => inProgress = false);
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
          ),
          child: Text("reject".t),
        ),
      ],
    );
  }
}
