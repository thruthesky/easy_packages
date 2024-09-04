import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';

/// Display a few chat room invitations as a list.
///
///
class ChatInvitationListView extends StatefulWidget {
  const ChatInvitationListView({
    super.key,
    this.limit = 3,
    this.padding,
    this.itemBuilder,
    this.separatorBuilder,
    this.bottomWidget = const Divider(),
  });

  final int limit;

  final EdgeInsetsGeometry? padding;

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget? bottomWidget;

  @override
  State<ChatInvitationListView> createState() => ChatInvitationListViewState();
}

class ChatInvitationListViewState extends State<ChatInvitationListView> {
  ChatInvitationListViewState();

  Map<String, int> invites = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // TODO must listen because this is invitation list view
    final DatabaseEvent event =
        await ChatService.instance.invitedUserRef(myUid!).once();
    if (event.snapshot.exists) {
      invites = Map<String, int>.from(event.snapshot.value as Map);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (invites.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<String> roomIds = invites.keys.take(widget.limit).toList();

    // final chatRooms = docs.map((doc) => ChatRoom.fromSnapshot(doc)).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            ChatService.instance.showInviteListScreen(context);
          },
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 4),
                ChatInvitationCount(
                  builder: (int no) =>
                      ChatService.instance.newMessageBuilder?.call("$no") ??
                      Badge(label: Text("$no")),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "message request/invitations".t,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (roomIds.length > 3) ...[
                  Text(
                    'view all invitations'.t,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: roomIds.length,
          separatorBuilder: widget.separatorBuilder ??
              (context, index) => const SizedBox.shrink(),
          itemBuilder: (listViewContext, index) {
            return ChatRoomDoc(
                ref: ChatService.instance.roomRef(roomIds[index]),
                builder: (room) {
                  return widget.itemBuilder?.call(context, room, index) ??
                      ChatRoomInvitationListTile(
                        room: room,
                        onAccept: (room, user) async {
                          await ChatService.instance.showChatRoomScreen(
                            context,
                            room: room,
                            user: user,
                          );
                        },
                      );
                });
          },
        ),
        if (widget.bottomWidget != null) widget.bottomWidget!,
      ],
    );
  }
}
