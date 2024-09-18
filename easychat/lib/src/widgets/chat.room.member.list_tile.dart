import 'package:cached_network_image/cached_network_image.dart';
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
              // REVIEW UserAvatar
              // Something is wrong in the User Avatar
              // Somehow, the image must reload whenever we need
              // to show it. (upon testing in real iPhone Device)
              //
              // It may be because of ThumbnailImage.
              // Upon checking it is calling the thumbnail image first.
              // When it errors, it shows the original image.
              //
              // child: UserAvatar(user: user),
              //
              // For now, using this:
              child: user.photoUrl != null
                  ? ClipRRect(
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
                          imageUrl: user.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : UserAvatar.buildAnonymouseAvatar(size: 48),
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
