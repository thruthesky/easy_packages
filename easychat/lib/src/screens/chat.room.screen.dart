import 'dart:async';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat room screen
///
/// TODO: chat join has some information about the room data.
/// TODO: if join data is single chat room,
/// (1) display title with displayName and photo.
/// (2) diplay the chat message list and chat input if possible
/// (3) load the chat room and user data.
///
/// TODO: if join data is a group chat,
/// (1) display title with name and iconUrl.
/// (2) display the chat message list and chat input if possible
/// (3) load the chat room data.
///
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    this.room,
    this.user,
    this.join,
  }) : assert(room != null || user != null || join != null);

  final ChatRoom? room;
  final User? user;
  final ChatJoin? join;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  ChatRoom? room;
  User? user;

  StreamSubscription? resetMessageCountSubscription;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    init();
  }

  init() async {
    if (widget.join != null) {
      if (widget.join!.group) {
        room = await ChatRoom.get(widget.join!.roomId);
      } else {
        room = await ChatRoom.get(widget.join!.roomId);
        user = await User.get(getOtherUserUidFromRoomId(widget.join!.roomId)!);
      }
      setState(() {});
    } else if (widget.user != null) {
      // Single chat. load room (or create)
      user = widget.user;
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
    room = await ChatRoom.get(singleChatRoomId(user!.uid));

    if (room == null) {
      final newRoomRef = await ChatRoom.createSingle(user!.uid);
      room = await ChatRoom.get(newRoomRef.key!);
      ChatService.instance.setJoin(room!);
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

  /// TODO: Listen the whole room info using `ChatRoomDoc`.

  @override
  Widget build(BuildContext context) {
    // * Note, scaffold will be displayed before room is ready.
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            appBarIcon(),
            Expanded(
              child: Text(roomTitle(room, user, widget.join)),
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
          ? ChatRoomDoc(
              roomId: room!.id,
              builder: (context) {
                return ChatRoomMenuDrawer(
                  room: room,
                  user: widget.user,
                );
              },
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
                  child: ChatRoomDoc(
                    roomId: room!.id,
                    onLoading: ChatRoomInputBox(
                      key: ValueKey("ChatRoomInputBox_${room?.id}"),
                      room: room!,
                    ),
                    builder: (room) {
                      return ChatRoomInputBox(
                        key: ValueKey("ChatRoomInputBox_${room.id}"),
                        room: room,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget appBarIcon() {
    Widget child;
    if (widget.join != null) {
      if (widget.join!.single) {
        child = chatIcon(widget.join?.photoUrl, false);
      } else {
        child = chatIcon(widget.join?.iconUrl, true);
      }
    } else if (user != null) {
      child = GestureDetector(
        child: UserAvatar(
          user: user!,
          size: 36,
          radius: 15,
        ),
        onTap: () => UserService.instance.showPublicProfileScreen(
          context,
          user: user!,
        ),
      );
    } else {
      child = chatIcon(widget.room?.iconUrl, true);
    }
    return Row(
      children: [
        child,
        const SizedBox(width: 8),
      ],
    );
  }

  Widget chatIcon(String? iconUrl, bool isGroup) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      width: 36,
      height: 36,
      clipBehavior: Clip.hardEdge,
      child: iconUrl != null && iconUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: iconUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                dog("Error in Image Chat Room Screen: $error");
                return const Icon(Icons.error);
              },
            )
          : (isGroup
              ? Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                )
              : CircleAvatar(
                  child: Text(
                    getOtherUserUidFromRoomId(widget.join!.roomId)!
                        .characters
                        .first
                        .toUpperCase(),
                  ),
                )),
    );
  }
}
