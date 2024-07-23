import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomMenuScreeen extends StatelessWidget {
  const ChatRoomMenuScreeen({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Room Menu"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Members"),
            onTap: () {
              ChatService.instance.showMemberListScreen(context, room);
            },
          ),
          ListTile(
            title: const Text("Invites"),
            onTap: () {
              ChatService.instance.showInviteListScreen(context, room: room);
            },
          ),
        ],
      ),
    );
  }
}
