import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.room.member.dialog.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';

class ChatRoomMemberListTile extends StatelessWidget {
  const ChatRoomMemberListTile({
    super.key,
    required this.user,
    required this.room,
  });

  final User user;
  final ChatRoom? room;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          UserService.instance.showPublicProfileScreen(
            context,
            user: user,
          );
        },
        child: UserAvatar(user: user),
      ),
      title: Text(
        user.displayName,
      ),
      subtitle: Text(
        user.createdAt?.short ?? '',
      ),
      trailing: const Icon(Icons.more_vert),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ChatRoomMemberDialog(room: room, user: user),
        );
      },
    );
  }
}
