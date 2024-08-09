import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class RejectedChatRoomInviteListScreen extends StatelessWidget {
  const RejectedChatRoomInviteListScreen({super.key});

  Query get query => ChatService.instance.roomCol.where(
        'rejectedUsers',
        arrayContains: my.uid,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rejected chat requests'.t),
      ),
      body: ChatRoomListView(
        queryOption: ChatRoomListOption.rejectedInvites,
        itemBuilder: (context, room, index) {
          return ChatRoomListTile(
            room: room,
            onTap: (context, room, user) async {
              final re = await confirm(
                context: context,
                title: Text('rejected chat'.t),
                message: const Text(
                  "You have rejected the chat already. Accept and continue chat?",
                ),
              );
              if (re ?? false) {
                await room.acceptInvitation();
              }
            },
          );
        },
      ),
    );
  }
}
