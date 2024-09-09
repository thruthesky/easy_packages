import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatRoomReceivedInviteListScreen extends StatelessWidget {
  const ChatRoomReceivedInviteListScreen({super.key});

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
            // Right now, this is the only place we are using
            // this ChatInvitationListView. Separate if it is going to be reused.
            : FirebaseDatabaseListView(
                query: FirebaseDatabase.instance
                    .ref()
                    .child("chat/invited-users/$myUid")
                    .orderByValue(),
                itemBuilder: (context, snapshot) {
                  return ChatRoomDoc(
                    roomId: snapshot.key!,
                    builder: (room) {
                      return ChatInvitationListTile(
                        room: room,
                        onAccept: (room, user) {
                          ChatService.instance.showChatRoomScreen(
                            context,
                            room: room,
                            user: user,
                          );
                        },
                      );
                    },
                  );
                  // },
                  // return ListTile(
                  //   title: Text(
                  //     snapshot.key!,
                  //   ),
                  //   onTap: () async {
                  //     final room = await ChatRoom.get(snapshot.key!);
                  //     ChatService.instance.accept(room!);
                  //   },
                  // );
                },
              )

        // FirestoreListView(
        //     query: ChatRoomQuery.receivedInvites(),
        //     itemBuilder: (context, doc) {
        //       return ChatRoomInvitationListTile(
        //         room: ChatRoom.fromSnapshot(doc),
        //         onAccept: (room, user) {
        //           ChatService.instance.showChatRoomScreen(
        //             context,
        //             room: room,
        //             user: user,
        //           );
        //         },
        //       );
        //     },
        //     emptyBuilder: (context) => Center(
        //       child: Text('no chat requests'.t),
        //     ),
        //   ),
        );
  }
}
