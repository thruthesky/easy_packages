import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.room.member.dialog.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';

class ChatRoomMemberListTile extends StatelessWidget {
  const ChatRoomMemberListTile({
    super.key,
    required this.user,
    required this.room,
  });

  final User user;
  final ChatRoom? room;

  @override
  Widget build(BuildContext context) {
    final blocked = UserService.instance.blockChanges.value.containsKey(user.uid);
    return ListTile(
      minTileHeight: 72,
      leading: blocked
          ? Container(
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
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                UserService.instance.showPublicProfileScreen(
                  context,
                  user: user,
                );
              },
              child: UserAvatar(photoUrl: user.photoUrl, initials: user.uid),
            ),
      title: blocked
          ? Text(
              "blocked user".t,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (room!.masterUsers.contains(user.uid))
                  Text(
                    " (Master)",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                          height: 1.7,
                        ),
                  ),
              ],
            ),
      subtitle: blocked
          ? null
          : user.stateMessage == null || user.stateMessage == ""
              ? null
              : Text(
                  user.stateMessage ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
      trailing: const Icon(Icons.more_vert),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ChatRoomMemberDialog(room: room, user: user),
        );
      },
    );
  }
}
