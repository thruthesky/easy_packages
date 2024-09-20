import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat room invitation list tile.
///
/// Use:
/// - To display the chat room invitation list on top of the chat room list.
/// - You may use it to display the invitation list on home screen.
class ChatInvitationListTile extends StatefulWidget {
  const ChatInvitationListTile({
    super.key,
    required this.room,
    required this.onAccept,
    this.onReject,
  });

  final ChatRoom room;
  final Function(ChatRoom room, User? user)? onAccept;
  final Function(ChatRoom room, User? user)? onReject;

  static const double _minTileHeight = 70;

  static const EdgeInsetsGeometry _contentPadding = EdgeInsets.symmetric(horizontal: 16);

  @override
  State<ChatInvitationListTile> createState() => _ChatInvitationListTileState();
}

class _ChatInvitationListTileState extends State<ChatInvitationListTile> {
  User? user;
  late final String otherUid;
  @override
  void initState() {
    super.initState();
    otherUid = getOtherUserUidFromRoomId(widget.room.id)!;
    User.get(otherUid).then((u) => user = u);
  }

  @override
  Widget build(BuildContext context) {
    dog("Initation List tile");
    if (widget.room.single == true) {
      return UserBlocked(
        otherUid: otherUid,
        builder: (blocked) {
          if (blocked) {
            return const SizedBox.shrink();
          }
          return ListTile(
            minTileHeight: ChatInvitationListTile._minTileHeight,
            leading: UserAvatar.fromUid(
              uid: otherUid,
              onTap: () => UserService.instance.showPublicProfileScreen(
                context,
                user: user!,
              ),
            ),
            title: DisplayName(uid: otherUid),
            subtitle: UserField<String?>(
                uid: otherUid,
                field: User.field.stateMessage,
                builder: (stateMessage) {
                  return Text(stateMessage ?? '');
                }),
            trailing: ChatInvitationListTileActions(
              onTapAccept: () => onTapAccept(user),
              onTapReject: () => onTapReject(user),
            ),
            contentPadding: ChatInvitationListTile._contentPadding,
          );
        },
      );
    }

    // else, it means it is a group chat
    return ListTile(
      minTileHeight: ChatInvitationListTile._minTileHeight,
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        width: 48,
        height: 48,
        clipBehavior: Clip.hardEdge,
        child: widget.room.iconUrl != null && widget.room.iconUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.room.iconUrl!,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.people,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
      ),
      title: Text(
        widget.room.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.room.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: ChatInvitationListTileActions(
        onTapAccept: onTapAccept,
        onTapReject: onTapReject,
      ),
      contentPadding: ChatInvitationListTile._contentPadding,
    );
  }

  Future onTapAccept([User? user]) async {
    await ChatService.instance.accept(widget.room);
    widget.onAccept?.call(widget.room, user);
  }

  Future onTapReject([User? user]) async {
    await ChatService.instance.reject(widget.room);
    widget.onReject?.call(widget.room, user);
  }
}
