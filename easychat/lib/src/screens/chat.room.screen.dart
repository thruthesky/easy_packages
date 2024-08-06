import 'dart:async';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easychat/src/widgets/chat.room.menu.drawer.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    this.room,
    this.user,
  }) : assert(room != null || user != null);

  final ChatRoom? room;
  final User? user;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  ChatRoom? $room;
  User? $user;

  StreamSubscription? docUpdateStream;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    $room = widget.room;
    $user = widget.user;

    // Single chat
    //
    // If room is null, user should not be null.
    // We have to get room from other user.
    if ($room == null) {
      await loadOrCreateRoomForSingleChat();
    } else if ($user == null && $room!.single) {
      $user = await User.get(getOtherUserUidFromRoomId($room!.id)!);
    }

    setState(() {});
    $room!.listen();
    $room!.updateMyReadMeta();
    onUpdateRoom();
  }

  @override
  dispose() {
    docUpdateStream?.cancel();
    $room?.dispose();
    super.dispose();
  }

  Future<void> loadOrCreateRoomForSingleChat() async {
    $room = await ChatRoom.get(singleChatRoomId($user!.uid));
    if ($room != null) return;
    // In case the room doesn't exists, we create the room.
    // Automatically this will invite the other user.
    // The other user wont normally see the message in chat room
    // list. However the other user may see the messages if the
    // other user opens the chat room.
    final newRoomRef = await ChatRoom.createSingle($user!.uid);
    $room = await ChatRoom.get(newRoomRef.id);
  }

  onUpdateRoom() {
    // This will update the current user's read if
    // there is a new message.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      docUpdateStream = $room!.changes.listen(
        (room) => room.updateMyReadMeta(),
      );
    });
  }

  String title(ChatRoom room) {
    // Single chat or gruop chat can have name.
    if (room.name.trim().isNotEmpty) {
      return room.name;
    }
    //
    if ($user != null) {
      return $user!.displayName.or('No name');
    }
    return 'Chat Room';
  }

  String notMemberMessage(ChatRoom room) {
    if (room.invitedUsers.contains(my.uid)) {
      // The user has a chance to open the chat room with message
      // when the other user sent a message (1:1) but the user
      // haven't accepted yet.
      return "You haven't accepted this chat yet. Once you send a message, the chat is automatically accepted.";
    }
    if (room.rejectedUsers.contains(my.uid)) {
      return "You have rejected this chat. However, if you sent a reply, the chat is automatically accepted.";
    }
    if (room.group) {
      // For open chat rooms, the rooms can be seen by users.
      return "This is an open group. Once you sent a message, you will automatically join the group.";
    }
    // Else, it should be handled by the Firestore rulings.
    return "The Chat Room may be private and/or deleted.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: $room?.builder(
          (room) => Row(
            children: [
              if (room.group) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.hardEdge,
                  child: room.iconUrl != null && room.iconUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: room.iconUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            dog("Error in Image Chat Room Screen: $error");
                            return const Icon(Icons.error);
                          },
                        )
                      : const Icon(Icons.people),
                ),
                const SizedBox(width: 12),
              ] else if (room.single) ...[
                GestureDetector(
                  child: UserAvatar(
                    user: $user!,
                    size: 36,
                    radius: 15,
                  ),
                  onTap: () => UserService.instance.showPublicProfileScreen(
                    context,
                    user: $user!,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(title(room)),
              ),
            ],
          ),
        ),
      ),
      endDrawer: $room?.builder(
        (room) => ChatRoomMenuDrawer(
          room: room,
          user: $user,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ($room == null)
            const Center(child: CircularProgressIndicator.adaptive())
          else ...[
            Expanded(
              child: $room!.joined ||
                      $room!.open ||
                      $room!.invitedUsers.contains(my.uid) ||
                      $room!.rejectedUsers.contains(my.uid)
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: ChatMessagesListView(room: $room!),
                    )
                  : const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text("Unable to show chat messages."),
                      ),
                    ),
            ),
            // There is a chance for user to open the chat room
            // if the user is not a member of the chat room
            if (!$room!.joined) ...[
              $room!.builder((room) {
                if (room.joined) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: Text(
                    notMemberMessage(room),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              }),
            ],
            SafeArea(
              top: false,
              child: $room == null
                  ? const SizedBox.shrink()
                  : $room!.builder((room) => ChatRoomInputBox(room: room)),
            ),
          ],
        ],
      ),
    );
  }
}
