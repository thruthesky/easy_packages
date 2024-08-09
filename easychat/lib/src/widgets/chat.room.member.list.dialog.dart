import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomMemberListDialog extends StatefulWidget {
  const ChatRoomMemberListDialog({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  State<ChatRoomMemberListDialog> createState() =>
      _ChatRoomMemberListDialogState();
}

class _ChatRoomMemberListDialogState extends State<ChatRoomMemberListDialog> {
  @override
  void dispose() {
    super.dispose();
  }
  // padding: EdgeInsets.fromLTRB(16, 16, 16, 0),

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final maxHeight = height * 0.8;
    final width = MediaQuery.of(context).size.width;
    final maxWidth = width * 0.8;
    return AlertDialog(
      title:  Text(
        "Members".,
      ),
      contentPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: ListView.builder(
          itemCount: widget.room.userUids.length,
          itemBuilder: (context, index) {
            return UserDoc(
              uid: widget.room.userUids[index],
              builder: (user) {
                if (user == null) {
                  return const SizedBox.shrink();
                }
                return UserListTile(user: user);
              },
            );
          },
        ),
      ),
    );
  }
}
