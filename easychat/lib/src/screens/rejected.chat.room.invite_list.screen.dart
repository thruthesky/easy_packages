import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
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
        title: Text('rejected chat requests'.t),
      ),
      body: myUid == null
          ? Center(child: Text('sign-in first'.t))
          : FirestoreListView(
              query: ChatRoomQuery.rejectedInvites(),
              itemBuilder: (context, doc) {
                return ChatRoomListTile(
                  room: ChatRoom.fromSnapshot(doc),
                  onTap: (context, room, user) async {
                    final re = await confirm(
                      context: context,
                      title: Text('rejected chat'.t),
                      message: Text(
                        "you have rejected chat already, accept the chat instead?"
                            .t,
                      ),
                    );
                    if (re ?? false) {
                      await room.acceptInvitation();
                    }
                  },
                );
              },
              emptyBuilder: (context) => Center(
                child: Text('no chat rejected'.t),
              ),
            ),
    );
  }
}
