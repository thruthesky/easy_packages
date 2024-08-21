import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomMemberListDialog extends StatelessWidget {
  const ChatRoomMemberListDialog({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final maxHeight = height * 0.8;
    final width = MediaQuery.of(context).size.width;
    final maxWidth = width * 0.8;
    return AlertDialog(
      title: Text(
        "members".t,
      ),
      contentPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: ListView.builder(
          itemCount: room.userUids.length,
          itemBuilder: (context, index) {
            return UserDoc(
              uid: room.userUids[index],
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
