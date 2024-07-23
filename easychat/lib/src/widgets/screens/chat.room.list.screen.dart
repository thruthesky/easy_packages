import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomList';
  const ChatRoomListScreen({super.key});

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  Query get query =>
      ChatService.instance.roomCol.where('users', arrayContains: my.uid);

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
        itemBuilder: (context, doc) {
          final room = ChatRoom.fromSnapshot(doc);
          return ListTile(
            title: Text(room.id),
            onTap: () => ChatService.instance.showChatRoomScreen(
              context,
              room: room,
            ),
          );
        },
      ),
    );
  }
}
