import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
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
            // : const Text('TODO: invitation list screen'),
            // TODO: Use ChatInvitationListView instead.
            : FirebaseDatabaseListView(
                query: FirebaseDatabase.instance
                    .ref()
                    .child("chat/invited-users/$myUid"),
                itemBuilder: (context, snapshot) {
                  //   final room = ChatRoom.fromSnapshot(snapshot);
                  //   return ChatRoomInvitationListTile(
                  //     room: room,
                  //     onAccept: (room, user) {
                  //       ChatService.instance.showChatRoomScreen(
                  //         context,
                  //         room: room,
                  //         user: user,
                  //       );
                  //     },
                  //   );
                  // },
                  return ListTile(
                    title: Text(
                      snapshot.key!,
                    ),
                    onTap: () async {
                      final room = await ChatRoom.get(snapshot.key!);
                      ChatService.instance.accept(room!);
                    },
                  );
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
