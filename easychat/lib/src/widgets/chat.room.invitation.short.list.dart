import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomInvitationShortList extends StatelessWidget {
  const ChatRoomInvitationShortList({
    super.key,
    this.padding,
  });

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatService.instance.roomCol
          .where('invitedUsers', arrayContains: my.uid)
          .orderBy(ChatRoom.field.updatedAt, descending: true)
          .limit(4)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          dog('chat.room.list_view.dart Something went wrong: ${snapshot.error}');
          return Text('Something went wrong: ${snapshot.error}');
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
                  Badge(
                    label: Text(
                        "${chatRooms.length < 4 ? chatRooms.length : '3+'}"),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      "Message Requests/Invitations!",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chatRooms.length,
              itemBuilder: (listViewContext, index) {
                final room = chatRooms[index];
                // The fourth invitation and other nexts should be in
                // see more.
                if (index == 3 && chatRooms.length == 4) {
                  return TextButton(
                    style: TextButton.styleFrom(),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("See more requests..."),
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
                return ChatRoomInvitationListTile(
                  room: room,
                  afterAccept: (room, user) async {
                    await ChatService.instance.showChatRoomScreen(
                      context,
                      room: room,
                      user: user,
                    );
                  },
                );
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
