import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.room.list_tile.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatelessWidget {
  static const String routeName = '/ChatRoomList';
  const ChatRoomListScreen({
    super.key,
    this.group = false,
    this.open = false,
    this.single = false,
  });

  // For now we are doing boolean to prevent premature optimization
  final bool? open;
  final bool? group;
  final bool? single;

  Query get query {
    Query q = ChatService.instance.roomCol;
    if (single == true) {
      q = q
          .where('single', isEqualTo: true)
          .where('users', arrayContains: my.uid);
    }
    if (group == true) {
      q = q
          .where('group', isEqualTo: true)
          .where('users', arrayContains: my.uid);
    }

    if (open == true) {
      q = q.where('open', isEqualTo: true);
    }

    /// TODO: Issue: Chat rooms with new message must be put on the top. So, order by `updatedAt` will not work.
    /// To make it work, each user must maintain their own list of chat join relation which is good for rtdb.
    q = q.orderBy('updatedAt', descending: true);

    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room List'),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showChatRoomEditScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FirestoreListView(
        query: query,
        errorBuilder: (context, error, stackTrace) {
          dog('Something went wrong: $error');
          return Center(child: Text('Something went wrong: $error'));
        },
        itemBuilder: (context, doc) {
          final room = ChatRoom.fromSnapshot(doc);
          return ChatRoomListTile(
            room: room,
          );
        },
      ),
    );
  }
}
