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
  List<String> get allInvitedUsers {
    final List<String> allUids = [];
    allUids.addAll(widget.room.invitedUsers);
    allUids.addAll(widget.room.rejectedUsers);
    return allUids;
  }

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
              if (widget.room.invitedUsers.contains(invitedUser.uid) ||
                  widget.room.userUids.contains(invitedUser.uid) ||
                  // the users who rejected earlier must not be invited as well
                  widget.room.rejectedUsers.contains(invitedUser.uid)) {
                throw 'chat-room/invited-user-already-invited The user is already invited or a member.';
              }
              widget.room.inviteUser(invitedUser.uid);
              widget.room.invitedUsers.add(invitedUser.uid);
              if (!mounted) return;
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemExtent: 72,
        itemBuilder: (context, index) {
          return UserDoc(
            uid: allInvitedUsers[index],
            builder: (user) => user == null
                ? const SizedBox.shrink()
                : UserListTile(user: user),
          );
        },
        itemCount: allInvitedUsers.length,
      ),
    );
  }
}
