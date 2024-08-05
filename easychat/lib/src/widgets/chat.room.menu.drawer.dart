import 'package:cached_network_image/cached_network_image.dart';
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
        child: ListTileTheme(
          data: const ListTileThemeData(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (room.group) ...[
                Container(
                  height: 200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: room.iconUrl != null && room.iconUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: room.iconUrl!,
                          fit: BoxFit.cover,
                        )
                      : const SafeArea(
                          child: Icon(Icons.people, size: 64),
                        ),
                ),
                const SizedBox(height: 24),
                horizontalPadding(
                  child: Text(
                    room.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                horizontalPadding(
                  child: Text(
                    room.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 24),
                label(
                    context: context,
                    text: "Members (${room.userUids.length})"),
                const SizedBox(height: 8),
                // TODO see more users.
                // For now it will only show up to 3 users
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
                  itemCount:
                      room.userUids.length >= 4 ? 3 : room.userUids.length,
                ),
                if (room.userUids.length >= 4) ...[
                  ListTile(
                    title: const Text("See All Members"),
                    onTap: () {
                      // openMemberListDrawer(context);
                      onTapSeeMoreMembers?.call();
                    },
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
              ] else if (room.single) ...[
                // TODO dry
                Container(
                  height: 200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: user != null &&
                          user!.photoUrl != null &&
                          user!.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: user!.photoUrl!,
                          fit: BoxFit.cover,
                        )
                      : const SafeArea(
                          child: Icon(Icons.person, size: 64),
                        ),
                ),
                const SizedBox(height: 24),
                horizontalPadding(
                  child: Text(
                    user!.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (user!.stateMessage != null &&
                    user!.stateMessage!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  horizontalPadding(
                    child: Text(
                      user!.stateMessage!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              label(context: context, text: "Options"),
              const SizedBox(height: 8),
              if (room.joined) ...[
                if (room.group && room.masterUsers.contains(my.uid))
                  ListTile(
                    title: const Text("Update"),
                    onTap: () {
                      ChatService.instance
                          .showChatRoomEditScreen(context, room: room);
                    },
                  ),
                if (room.group)
                  ListTile(
                      title: const Text("Leave"),
                      onTap: () {
                        room.leave();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }),
              ],
              if (room.single)
                ListTile(
                  title: const Text("Block"),
                  onTap: () {
                    // TODO review if this is the correct way
                    UserService.instance
                        .block(context: context, otherUid: user!.uid);
                  },
                ),
              // ListTile(
              //   title: const Text("Report"),
              //   onTap: () {
              // TODO review if is this the correct way
              // ReportService.instance.report(
              //   context: context,
              //   documentReference: user!.doc,
              //   otherUid: user!.uid,
              // );
              //   },
              // ),
              const SizedBox(
                height: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
