import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Display a few chat room invitations as a list.
///
///
class ChatRoomInvitationShortList extends StatelessWidget {
  const ChatRoomInvitationShortList({
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
  Widget build(BuildContext context) {
    return DatabaseLimitedListView(
      // No longer limiting. //
      // However, it may cost more read for users who don't accept or
      // reject chat rooms. But it is not common.
      // stream: ChatRoomQuery.receivedInvites().limit(10).snapshots(),
      stream: ChatRoomQuery.receivedInvites().limit(4).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          dog('chat.room.list_view.dart Something went wrong: ${snapshot.error}');
          return Text('${'something went wrong'.t}: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        final docs = snapshot.data!.docs;
        final chatRooms =
            docs.map((doc) => ChatRoom.fromSnapshot(doc)).toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                ChatService.instance.showInviteListScreen(context);
              },
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
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
                    if (docs.length > 3) ...[
                      Text(
                        'view all invitations'.t,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
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
              itemCount: chatRooms.length <= 3 ? chatRooms.length : 3,
              separatorBuilder: separatorBuilder ??
                  (context, index) => const SizedBox.shrink(),
              itemBuilder: (listViewContext, index) {
                final room = chatRooms[index];
                return itemBuilder?.call(context, room, index) ??
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
              },
            ),
            if (bottomWidget != null) bottomWidget!,
          ],
        );
      },
    );
  }
}
