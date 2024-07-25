import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.room.list_tile.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class RejectedChatRoomInviteListScreen extends StatefulWidget {
  const RejectedChatRoomInviteListScreen({super.key});

  @override
  State<RejectedChatRoomInviteListScreen> createState() =>
      _RejectedChatRoomInviteListScreenState();
}

class _RejectedChatRoomInviteListScreenState
    extends State<RejectedChatRoomInviteListScreen> {
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
          // return ListTile(
          //   title: Text(room.id),
          //   // onTap: () => ChatService.instance.showChatRoomScreen(
          //   //   context,
          //   //   room: room,
          //   // ),
          // );
          return ChatRoomListTile(
            room: room,
            onTap: (room) async {
              final re = await confirm(
                context: context,
                title: "Rejected Chat",
                message:
                    "You have rejected the chat already. Accept and continue chat?",
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
