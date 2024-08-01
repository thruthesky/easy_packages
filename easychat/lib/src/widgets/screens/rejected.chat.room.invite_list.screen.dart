import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
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
        title: const Text("Rejected Chat Requests"),
      ),
      body: FirestoreListView(
        query: query,
        itemBuilder: (context, doc) {
          final room = ChatRoom.fromSnapshot(doc);
          return ChatRoomListTile(
            room: room,
            onTap: (context, room, user) async {
              final re = await confirm(
                context: context,
                title: const Text("Rejected Chat"),
                message: const Text(
                    "You have rejected the chat already. Accept and continue chat?"),
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
