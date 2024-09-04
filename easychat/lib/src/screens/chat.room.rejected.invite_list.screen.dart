import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatRoomRejectedInviteListScreen extends StatelessWidget {
  const ChatRoomRejectedInviteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('rejected chat requests'.t),
      ),
      body: myUid == null
          ? Center(child: Text('sign-in first'.t))
          // : const Text('TODO: rejected list screen'),

          : FirebaseDatabaseListView(
              query: ChatService.instance.rejectedUserRef(myUid!),
              itemBuilder: (context, snapshot) {
                return ChatRoomDoc(
                    ref: ChatService.instance.roomRef(snapshot.key!),
                    builder: (room) {
                      return ChatRoomListTile(
                        room: room,
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
                            await ChatService.instance.accept(room);
                          }
                        },
                      );
                    });
              },
            ),
    );
  }
}
