import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomMemberDialog extends StatelessWidget {
  const ChatRoomMemberDialog({
    super.key,
    required this.room,
    required this.user,
  });

  final ChatRoom? room;
  final User user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              UserService.instance.showPublicProfileScreen(
                context,
                user: user,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(user: user),
                const SizedBox(height: 8),
                if (user.displayName.isNotEmpty)
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          if (room?.masterUsers.contains(myUid) == true) ...[
            if (user.uid != myUid &&
                room?.blockedUsers.contains(user.uid) == false) ...[
              const Divider(
                height: 0,
              ),
              InkWell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Block",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                onTap: () {
                  room!.block(user.uid);
                  Navigator.of(context).pop();
                },
              ),
            ],
            if (room?.blockedUsers.contains(user.uid) == true &&
                user.uid != myUid) ...[
              const Divider(
                height: 0,
              ),
              InkWell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Unblock",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                onTap: () {
                  room!.unblock(user.uid);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}
