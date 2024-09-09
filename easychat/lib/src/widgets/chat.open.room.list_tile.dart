import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Display open chat room in list tile
class ChatOpenRoomListTile extends StatelessWidget {
  ChatOpenRoomListTile({
    super.key,
    required this.room,
  }) : assert(room.open == true);

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
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
      onTap: () async {
        if (room.joined == false) {
          await ChatService.instance.join(room);
        }
        if (!context.mounted) return;
        await ChatService.instance.showChatRoomScreen(context, room: room);
      },
    );
  }
}
