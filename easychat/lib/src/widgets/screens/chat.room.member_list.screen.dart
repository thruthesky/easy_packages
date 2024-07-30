import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomMemberListScreen extends StatelessWidget {
  const ChatRoomMemberListScreen({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member List"),
      ),
      body: ListView.builder(
        itemExtent: 72,
        itemBuilder: (context, index) {
          return UserDoc(
            uid: room.users.keys.toList()[index],
            builder: (user) => user == null
                ? const SizedBox.shrink()
                : UserListTile(user: user),
          );
        },
        itemCount: room.users.length,
      ),
    );
  }
}
