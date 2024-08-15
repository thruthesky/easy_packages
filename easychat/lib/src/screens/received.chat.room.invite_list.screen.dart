import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ReceivedChatRoomInviteListScreen extends StatefulWidget {
  const ReceivedChatRoomInviteListScreen({super.key});

  @override
  State<ReceivedChatRoomInviteListScreen> createState() =>
      _ReceivedChatRoomInviteListScreenState();
}

class _ReceivedChatRoomInviteListScreenState
    extends State<ReceivedChatRoomInviteListScreen> {
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
              query: ChatQuery.inviteList,
              itemBuilder: (context, doc) {
                return ChatRoomInvitationListTile(
                  room: ChatRoom.fromSnapshot(doc),
                );
              },
              emptyBuilder: (context) => Center(
                child: Text('no chat requests'.t),
              ),
            ),
    );
  }
}
