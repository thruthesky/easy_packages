import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ReceivedChatRoomInviteListScreen extends StatefulWidget {
  const ReceivedChatRoomInviteListScreen({super.key});

  @override
  State<ReceivedChatRoomInviteListScreen> createState() =>
      _ReceivedChatRoomInviteListScreenState();
}

class _ReceivedChatRoomInviteListScreenState
    extends State<ReceivedChatRoomInviteListScreen> {
  Query get query =>
      ChatService.instance.roomCol.where('invitedUsers', arrayContains: my.uid);

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
      body: ChatRoomListView(
        queryOption: ChatRoomListOption.receivedInvites,
        itemBuilder: (context, room, index) {
          return ChatRoomInvitationListTile(
            room: room,
          );
        },
      ),
    );
  }
}
