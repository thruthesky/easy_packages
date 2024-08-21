import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomInvitationShortList extends StatelessWidget {
  const ChatRoomInvitationShortList({
    super.key,
    this.padding,
    this.itemBuilder,
    this.separatorBuilder,
    this.bottomWidget = const Divider(),
  });

  final EdgeInsetsGeometry? padding;

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // No longer limiting. //
      // However, it may cost more read for users who don't accept or
      // reject chat rooms. But it is not common.
      // stream: ChatRoomQuery.receivedInvites().limit(10).snapshots(),
      stream: ChatRoomQuery.receivedInvites().snapshots(),
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
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: Row(
                children: [
                  ChatService.instance.chatRoomInvitationCountBuilder
                          ?.call(chatRooms.length) ??
                      Badge(
                        label: Text("${chatRooms.length}"),
                      ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "message request/invitations".t,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chatRooms.length <= 3 ? chatRooms.length : 4,
              separatorBuilder: separatorBuilder ??
                  (context, index) => const SizedBox.shrink(),
              itemBuilder: (listViewContext, index) {
                final room = chatRooms[index];
                // The fourth invitation and other nexts should be in
                // see more.
                if (index == 3 && chatRooms.length > 3) {
                  return TextButton(
                    style: TextButton.styleFrom(),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('see more requests'.t),
                      ),
                    ),
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, a1, a2) {
                          return const ReceivedChatRoomInviteListScreen();
                        },
                      );
                    },
                  );
                }
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
