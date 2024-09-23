import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Display open chat room in list tile
class ChatRejectedListTile extends StatelessWidget {
  const ChatRejectedListTile({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    if (room.group) {
      return ListTile(
        minTileHeight: 72,
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          width: 48,
          height: 48,
          clipBehavior: Clip.hardEdge,
          child: (room.iconUrl?.trim() ?? "").isNotEmpty
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
          room.name.trim().isNotEmpty ? room.name : "group chat".t,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: room.description.trim().isEmpty
            ? null
            : Text(
                room.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(90),
                ),
              ),
        trailing: Text((room.updatedAt).short),
        onTap: () => onTap(context),
      );
    } else if (room.single) {
      final otherUid = getOtherUserUidFromRoomId(room.id)!;
      return UserBlocked(
        otherUid: otherUid,
        builder: (blocked) {
          if (blocked) {
            // REVIEW: need to review because this wont do since we use separator
            return const SizedBox.shrink();
          }
          return ListTile(
            minTileHeight: 72,
            leading: UserAvatar.fromUid(
              uid: otherUid,
              size: 48,
              radius: 24,
            ),
            title: UserField<String?>(
              uid: otherUid,
              field: 'displayName',
              builder: (displayName) {
                return Text(roomTitle(room, displayName ?? '', null));
              },
            ),
            onTap: () => onTap(context),
          );
        },
      );
    } else {
      throw 'Unexpected error';
    }
  }

  onTap(BuildContext context) async {
    final re = await confirm(
      context: context,
      title: Text('rejected chat'.t),
      message: Text(
        "you have rejected chat already, accept the chat instead?".t,
      ),
    );
    if (re ?? false) {
      await ChatService.instance.accept(room);
      if (!context.mounted) return;
      // Unable to make this work because of context
      await ChatService.instance.showChatRoomScreen(context, room: room);
    }
  }
}
