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
      // TODO
      body: ListView.builder(
        itemBuilder: (context, index) {
          // return ListTile(
          //   title: Text(room.users[index]),
          // );
          return UserDoc(
            uid: room.users.keys.toList()[index],
            builder: (user) => user == null
                ? const SizedBox.shrink()
                : UserListTile(user: user),
          ); // only uid
        },
        itemCount: room.users.length,
      ),
    );
  }
}
