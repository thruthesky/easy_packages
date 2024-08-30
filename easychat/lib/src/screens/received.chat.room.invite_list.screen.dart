import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ReceivedChatRoomInviteListScreen extends StatelessWidget {
  const ReceivedChatRoomInviteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('accept/reject chat requests'.t),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showRejectListScreen(context);
            },
            icon: const Icon(Icons.archive),
          ),
        ],
      ),
      body: myUid == null
          ? Center(child: Text('sign-in first'.t))
          : FirestoreListView(
              query: ChatRoomQuery.receivedInvites(),
              itemBuilder: (context, doc) {
                return ChatRoomInvitationListTile(
                  room: ChatRoom.fromSnapshot(doc),
                  onAccept: (room, user) {
                    ChatService.instance.showChatRoomScreen(
                      context,
                      room: room,
                      user: user,
                    );
                  },
                );
              },
              emptyBuilder: (context) => Center(
                child: Text('no chat requests'.t),
              ),
            ),
    );
  }
}
