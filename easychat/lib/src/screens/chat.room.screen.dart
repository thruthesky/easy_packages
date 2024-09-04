import 'dart:async';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat room screen
///
///
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
  ChatRoom? room;

  StreamSubscription? resetMessageCountSubscription;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    init();
  }

  init() async {
    // Single chat.
    //
    // If room is null, user should not be null.
    // We have to get room from other user.
    if (widget.user != null) {
      // Create chat room if user is set.
      await loadOrCreateSingleChatRoom();

      setState(() {});
    }

    await onRoomReady();
  }

  // bool get shouldJoinOpenGroupChat =>
  //     !$room!.userUids.contains(myUid) && $room!.open && $room!.group;

  // bool get shouldJoinSingleChat =>
  //     !$room!.userUids.contains(myUid) &&
  //     $room!.single &&
  //     $room!.uidsFromRoomId.contains(myUid) &&
  //     !$room!.invitedUsers.contains(myUid) &&
  //     !$room!.rejectedUsers.contains(myUid);

  /// Do something when the room is ready
  ///
  /// The "room ready" means that the room is existing or created, and loaded.
  onRoomReady() async {
    // TODO: check if the user is blocked

    // TODO: check if the user is a membmer

    // TODO: check if the user is in invitation list

    // TODO: check if the user is in rejected list

    // TODO: check if the user can join the chat room

    // if (room!.blockedUsers.contains(myUid)) return;
    // // Auto Join Groups when it is open chat
    // if (shouldJoinOpenGroupChat || shouldJoinSingleChat) {
    //   isJoiningNow = true;
    //   await $room!.join();
    // }

    /// Set 0 to the new meessage count
    ///
    /// Whenever there is a new chat, reset the unread message count to 0.
    resetMessageCountSubscription = ChatService.instance
        .messageRef(room!.id)
        .limitToLast(1)
        .onChildAdded
        .listen(
      (event) {
        room!.resetUnreadMessage();
      },
    );

    //     ChatService.instance.roomRef(room!.id).onValue.listen(
    //   (event) {
    //     room!.resetUnreadMessage();
    //   },
    // );
  }

  @override
  dispose() {
    resetMessageCountSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadOrCreateSingleChatRoom() async {
    dog('chat.room.screen.dart: init() -> loadOrCreateSingleChatRoom()');
    room = await ChatRoom.get(singleChatRoomId(widget.user!.uid));

    if (room == null) {
      final newRoomRef = await ChatRoom.createSingle(widget.user!.uid);
      room = await ChatRoom.get(newRoomRef.key!);
    }
  }

  /// Returns true if the login user can view the chat messages.
  ///
  /// It check if
  /// - the user has already joined the chat room,
  ///   -- the user must joined the room even if it's open chat.
  /// - room is null (which means there is no room yet) and
  ///   user is not null (which means the room will be created when
  ///   sent the first message)
  ///
  bool get joined {
    return room?.joined == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: CONSIDER: If the user is not joined, don't show the app bar content.
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.user != null) ...[
              GestureDetector(
                child: UserAvatar(
                  user: widget.user!,
                  size: 36,
                  radius: 15,
                ),
                onTap: () => UserService.instance.showPublicProfileScreen(
                  context,
                  user: widget.user!,
                ),
              ),
              const SizedBox(width: 12),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                width: 36,
                height: 36,
                clipBehavior: Clip.hardEdge,
                child: room?.iconUrl != null && room!.iconUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: room!.iconUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          dog("Error in Image Chat Room Screen: $error");
                          return const Icon(Icons.error);
                        },
                      )
                    : Icon(
                        Icons.people,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(roomTitle(room, widget.user)),
            ),
          ],
        ),
        actions: room == null
            ? null
            : [
                if (ChatService.instance.chatRoomActionButton != null)
                  ChatService.instance.chatRoomActionButton!(room!),
                if (joined)
                  Builder(
                    builder: (context) {
                      return DrawerButton(
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                      );
                    },
                  )
              ],
      ),
      endDrawer: joined
          ? ChatRoomMenuDrawer(
              room: room,
              user: widget.user,
            )
          : null,
      body: room == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ChatMessagesListView(
                      key: const ValueKey("Chat Message List View"),
                      room: room!,
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: ChatRoomInputBox(
                    room: room!,
                    onSend: (text, photoUrl, replyTo) {
                      // Invite the other user in 1:1 chat
                      //
                      // Invite the other user if the other user is not invited yet.
                      // This is only for single chat.
                      //
                      // Refer README.md for more information.
                      // ChatService.instance.inviteOtherUserIfSingleChat(room!);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
