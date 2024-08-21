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
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              "members".t,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
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
