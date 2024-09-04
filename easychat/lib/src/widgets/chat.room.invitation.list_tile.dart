import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat room invitation list tile.
///
/// Use:
/// - To display the chat room invitation list on top of the chat room list.
/// - You may use it to display the invitation list on home screen.
class ChatRoomInvitationListTile extends StatefulWidget {
  const ChatRoomInvitationListTile({
    super.key,
    this.roomId,
    this.room,
    // TODO room
    this.onAccept,
    this.onReject,
  }) : assert(roomId != null || room != null);

  final String? roomId;
  final ChatRoom? room;
  final Function(ChatRoom room, User? user)? onAccept;
  final Function(ChatRoom room, User? user)? onReject;

  static const double _minTileHeight = 70;

  static const EdgeInsetsGeometry _contentPadding =
      EdgeInsets.symmetric(horizontal: 16);

  @override
  State<ChatRoomInvitationListTile> createState() =>
      _ChatRoomInvitationListTileState();
}

class _ChatRoomInvitationListTileState
    extends State<ChatRoomInvitationListTile> {
  ChatRoom? room;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    // TODO still ongoing - will continue here..
    init();
  }

  init() async {
    room = await ChatRoom.get(widget.roomId!);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (room == null) {
      return const ListTile(
        leading: CircularProgressIndicator(),
      );
    }
    if (room!.single == true) {
      return UserDoc.sync(
        uid: getOtherUserUidFromRoomId(room!.id)!,
        builder: (user) {
          return ListTile(
            minTileHeight: ChatRoomInvitationListTile._minTileHeight,
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
            contentPadding: ChatRoomInvitationListTile._contentPadding,
          );
        },
      );
    }

    // else, it means it is a group chat
    return ListTile(
      minTileHeight: ChatRoomInvitationListTile._minTileHeight,
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        width: 48,
        height: 48,
        clipBehavior: Clip.hardEdge,
        child: room!.iconUrl != null && room!.iconUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: room!.iconUrl!,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.people,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
      ),
      title: Text(
        room!.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        room!.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ChatRoomInvitationListTileActions(
        onTapAccept: onTapAccept,
        onTapReject: onTapReject,
      ),
      contentPadding: ChatRoomInvitationListTile._contentPadding,
    );
  }

  Future onTapAccept([User? user]) async {
    widget.onAccept?.call(room!, user);
    // TODO cleanup
    // await room!.acceptInvitation();
    await ChatService.instance.accept(room!);
  }

  Future onTapReject([User? user]) async {
    widget.onReject?.call(room!, user);
    // TODO cleanup
    // await room!.rejectInvitation();
    await ChatService.instance.reject(room!);
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
