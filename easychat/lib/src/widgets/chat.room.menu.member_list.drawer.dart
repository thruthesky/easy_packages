import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomMenuDrawer extends StatelessWidget {
  const ChatRoomMenuDrawer({
    super.key,
    required this.room,
    this.user,
  });

  final ChatRoom room;
  final User? user;

  Padding horizontalPadding({required Widget child}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      );

  Widget label({required BuildContext context, required String text}) => Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label(
                  context: context, text: "Members (${room.userUids.length})"),
              const SizedBox(height: 8),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: 72,
                itemBuilder: (context, index) {
                  return UserDoc(
                    uid: room.userUids[index],
                    builder: (user) => user == null
                        ? const SizedBox.shrink()
                        : UserListTile(user: user),
                  );
                },
                itemCount: room.userUids.length >= 4 ? 3 : room.userUids.length,
              ),
              if (room.userUids.length >= 4) ...[
                ListTile(
                  title: const Text("See All Members"),
                  onTap: () {},
                ),
              ],
              ListTile(
                title: const Text("Invite More Users"),
                onTap: () async {
                  final selectedUser =
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
                    exactSearch: true,
                  );
                  if (selectedUser == null) return;
                  if (selectedUser.uid == my.uid) {
                    throw 'chat-room/inviting-yourself You cannot invite yourself.';
                  }
                  if (room.invitedUsers.contains(selectedUser.uid)) {
                    throw 'chat-room/already-invited The user is already invited.';
                  }
                  if (room.userUids.contains(selectedUser.uid)) {
                    throw 'chat-room/already-member The user is already a member.';
                  }
                  if (room.rejectedUsers.contains(selectedUser.uid)) {
                    // throw 'chat-room/rejected The user has been rejected.';
                    // The chat room is already rejected by the other user, we are
                    // not showing if user rejected the invitation.
                    throw 'chat-room/already-invited The user is already invited.';
                  }
                  room.inviteUser(selectedUser.uid);
                },
              ),
            ]),
      ),
    );
  }
}
