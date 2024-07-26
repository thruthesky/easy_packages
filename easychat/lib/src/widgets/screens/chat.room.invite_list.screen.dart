import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomInviteListScreen extends StatefulWidget {
  const ChatRoomInviteListScreen({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  State<ChatRoomInviteListScreen> createState() =>
      _ChatRoomInviteListScreenState();
}

class _ChatRoomInviteListScreenState extends State<ChatRoomInviteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () async {
              final invitedUser =
                  await UserService.instance.showUserSearchDialog(
                context,
                itemBuilder: (user, index) {
                  return UserListTile(
                    user: user,
                    onTap: () {
                      Navigator.of(context).pop(user);
                    },
                  );
                },
                exactSearch: false,
              );
              if (invitedUser == null) return;
              widget.room.inviteUser(invitedUser.uid);
              widget.room.invitedUsers.add(invitedUser.uid);
              if (!mounted) return;
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.room.invitedUsers[index]),
          );
          // return UserListTile(user: user) only uid
        },
        itemCount: widget.room.invitedUsers.length,
      ),
    );
  }
}
