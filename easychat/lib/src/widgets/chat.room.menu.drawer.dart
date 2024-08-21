import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.room.member.list.dialog.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_report/easy_report.dart';

class ChatRoomMenuDrawer extends StatelessWidget {
  const ChatRoomMenuDrawer({
    super.key,
    this.room,
    this.user,
  });

  final ChatRoom? room;
  final User? user;

  Padding horizontalPadding({required Widget child}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: child,
      );
  double photoHeight(BuildContext context) =>
      200 + MediaQuery.of(context).padding.top;

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
        physics: const ClampingScrollPhysics(),
        child: ListTileTheme(
          data: const ListTileThemeData(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (room?.group == true) ...[
                Container(
                  height: photoHeight(context),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      room!.iconUrl != null && room!.iconUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: room!.iconUrl!,
                              fit: BoxFit.cover,
                            )
                          : const SafeArea(
                              child: Icon(Icons.people, size: 64),
                            ),
                      if (room!.masterUsers.contains(myUid))
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withAlpha(220),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.edit),
                            ),
                            onPressed: () async {
                              await ChatService.instance.showChatRoomEditScreen(
                                context,
                                room: room,
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                horizontalPadding(
                  child: Text(
                    room!.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                horizontalPadding(
                  child: Text(
                    room!.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                InkWell(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      label(
                        context: context,
                        text: "members counted"
                            .tr(args: {'num': room!.userUids.length}),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  onTap: () {
                    showMembersDialog(context);
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemExtent: 72,
                  itemBuilder: (context, index) {
                    return UserDoc(
                      uid: room!.userUids[index],
                      builder: (user) => user == null
                          ? const SizedBox.shrink()
                          : UserListTile(user: user),
                    );
                  },
                  itemCount:
                      room!.userUids.length >= 4 ? 3 : room!.userUids.length,
                ),
                if (room!.userUids.length >= 4) ...[
                  InkWell(
                    onTap: () {
                      showMembersDialog(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'and more members'.t,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('see all members'.t),
                    onTap: () {
                      showMembersDialog(context);
                    },
                  ),
                ],
                ListTile(
                  title: Text('invite more users'.t),
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
                      throw ChatException(
                        'inviting-yourself',
                        'you cannot invite yourself'.t,
                      );
                    }
                    if (room!.invitedUsers.contains(selectedUser.uid)) {
                      throw ChatException(
                        'already-invited',
                        'the user is already invited'.t,
                      );
                    }
                    if (room!.userUids.contains(selectedUser.uid)) {
                      throw ChatException(
                        'already-member',
                        'the user is already a member'.t,
                      );
                    }
                    if (room!.rejectedUsers.contains(selectedUser.uid)) {
                      // The chat room is already rejected by the other user, we are
                      // not showing if user rejected the invitation.
                      throw ChatException(
                        'already-invited',
                        'the user is already invited'.t,
                      );
                    }
                    await room!.inviteUser(selectedUser.uid);
                    if (!context.mounted) return;
                    alert(
                      context: context,
                      title: Text('invited user'.t),
                      message: Text(
                        // Check It translated properly
                        // "${selectedUser.displayName.isEmpty ? selectedUser.name : selectedUser.displayName} has been invited.",
                        'user has been invited'.tr(
                          args: {
                            'username': selectedUser.displayName.isEmpty
                                ? selectedUser.name
                                : selectedUser.displayName,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ] else if (room?.single == true || user != null) ...[
                Container(
                  height: photoHeight(context),
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
              if (user?.admin != true)
                label(context: context, text: "options".t),
              const SizedBox(height: 8),
              if (room?.joined == true) ...[
                if (room!.group && room!.masterUsers.contains(my.uid))
                  ListTile(
                    title: Text("update".t),
                    onTap: () {
                      ChatService.instance
                          .showChatRoomEditScreen(context, room: room);
                    },
                  ),
                if (room!.group)
                  ListTile(
                    title: Text("leave".t),
                    onTap: () async {
                      final re = await confirm(
                        context: context,
                        title: Text("leaving room".t),
                        message: Text('leaving room confirmation'.t),
                      );
                      if (re != true) return;
                      room!.leave();
                      if (!context.mounted) return;
                      // two pops since we are opening both
                      // drawer and room screen.
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
              ],
              if (user?.admin != true) ...[
                if (room?.single == true || user != null)
                  ListTile(
                    title: Text("block".t),
                    onTap: () async {
                      UserService.instance
                          .block(context: context, otherUid: user!.uid);
                    },
                  ),
                ListTile(
                  title: Text('report'.t),
                  onTap: () {
                    ReportService.instance.report(
                      context: context,
                      documentReference: room!.ref,
                      otherUid: user?.uid ?? room!.masterUsers.first,
                    );
                  },
                )
              ],
              const SizedBox(
                height: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChatService.instance.membersDialogBuilder
                ?.call(context, room!) ??
            ChatRoomMemberListDialog(room: room!);
      },
    );
  }
}
