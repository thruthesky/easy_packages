import 'package:cloud_firestore/cloud_firestore.dart';
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
  Query get query =>
      ChatService.instance.roomCol.where('invitedUsers', arrayContains: my.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Requests'),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showRejectListScreen(context);
            },
            icon: const Icon(Icons.archive),
          ),
        ],
      ),
      body: FirestoreQueryBuilder(
        query: query,
        builder: (context, snapshot, _) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          // TODO review if correct
          List<QueryDocumentSnapshot> filteredInvitation =
              snapshot.docs.where((doc) {
            List<dynamic>? arrayField = (doc.data() as Map)['rejectedUsers'];
            if (arrayField == null) return true;
            return !arrayField.contains(my.uid);
          }).toList();

          return ListView.builder(
            itemCount: filteredInvitation.length,
            itemBuilder: (context, index) {
              final doc = filteredInvitation[index];
              final room = ChatRoom.fromSnapshot(doc);

              return ListTile(
                title: Text(room.id),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await room.acceptInvitation();
                      },
                      child: const Text("Accept"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await room.rejectInvitation();
                      },
                      child: const Text("Reject"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
