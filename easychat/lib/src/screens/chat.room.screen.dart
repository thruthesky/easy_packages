import 'dart:async';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat room screen
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
  StreamSubscription? usersSubscription;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    user = widget.user;
    init();
  }

  init() async {
    // 1. Prepare room
    if (room == null) {
      // Create chat room if user is set.
      // This will load room either from widget.join or from widget.user.uid
      await loadRoomOrCreateSingleChatRoom();
      setState(() {});
    }
    // 2. Prepare other user
    if (user == null && isSingleChatRoom(widget.join?.roomId ?? room!.id)) {
      user = await User.get(getOtherUserUidFromRoomId(widget.join?.roomId ?? room!.id)!);
      setState(() {});
    }
    await onRoomReady();
  }

  Future<void> join() async {
    await ChatService.instance.join(room!);
    if (!mounted) return;
    setState(() {});
  }

  /// Do something when the room is ready
  /// The "room ready" means that the room is existing or created, and loaded.
  onRoomReady() async {
    if (room!.blockedUids.contains(myUid!)) {
      Navigator.of(context).pop();
      dog("The user cannot join the chat room because the user is blocked.");
      throw ChatException(
        "fail-join-blocked",
        "failed to join in the chat room, because the user is blocked".t,
      );
    }

    // Current user automatically joins upon viewing open rooms.
    if (room!.joined == false && room!.open) {
      await join();
    }

    // If current user is one of the user in the single chat room, can join
    if (room!.joined == false && room!.single && room!.id.split(chatRoomDivider).contains(myUid!)) {
      await join();
    }

    // If user is still not joined until this point,
    // must check if invited, or else user cannot see the room.
    if (room!.joined == false) {
      final invitation = await ChatService.instance.getInvitation(room!.id);
      final rejection = await ChatService.instance.getRejection(room!.id);
      if (invitation != null || rejection != null) {
        await join();
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        dog("The user cannot join the chat room because the user is not invited.");
        throw ChatException(
          "fail-join-no-invitation",
          "failed to join in the chat room, because the user is not invited".t,
        );
      }
    }

    // Listeners
    listenToUsersUpdate();
    listenToUnreadMessageCountUpdate();
  }

  /// To have real time updates for users
  /// This is related to sending message, auto invitation logics
  void listenToUsersUpdate() {
    usersSubscription = room!.ref.child("users").onValue.listen((e) {
      room!.users = Map<String, bool>.from(e.snapshot.value as Map);
      // THIS WILL NOT WORK if the user is looking at the drawer
      // This should be handled by Security
      // if (room!.userUids.contains(myUid!) == false && mounted) {
      //   Navigator.of(context).pop();
      //   dog("The user is no longer a member. Check if the user is just blocked or kicked out.");
      //   throw ChatException(
      //     "removed-from-chat",
      //     "removed from the chat".t,
      //   );
      // }
    });
  }

  /// Listen to the login user's chat room for the updates of unread message count.
  ///
  /// Why:
  /// - To reset the unread message count
  /// - To re-render the chat room in list view.
  ///
  /// What:
  /// - The listener will be triggered once when the user enters the room. If there is new message,
  ///  then, reset it.
  /// - Since the user is inside the room, the unread message count should be reset.
  void listenToUnreadMessageCountUpdate() {
    resetMessageCountSubscription = ChatService.instance.unreadMessageCountRef(room!.id).onValue.listen((e) async {
      final newMessageCount = (e.snapshot.value ?? 0) as int;
      if (newMessageCount == 0) return;
      await ChatService.instance.resetUnreadMessage(room!);
    });
  }

  @override
  dispose() {
    resetMessageCountSubscription?.cancel();
    usersSubscription?.cancel();
    super.dispose();
  }

  /// To load Room using the Id
  ///
  /// Load room using the room id from ChatJoin or using other user uid
  ///
  /// Join or User must be provided or else it will throw a null error
  /// It is already handled by assert on constructor
  Future<void> loadRoomOrCreateSingleChatRoom() async {
    room = await ChatRoom.get(widget.join?.roomId ?? singleChatRoomId(user!.uid));
    if (room != null) return;
    final newRoomRef = await ChatRoom.createSingle(user!.uid);
    room = await ChatRoom.get(newRoomRef.key!);
    ChatService.instance.join(
      room!,
      protocol: ChatProtocol.invitationNotSent,
    );
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
  bool get joined => room?.joined == true;

  @override
  Widget build(BuildContext context) {
    // * Note, scaffold will be displayed before room is ready.
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            appBarIcon(),
            Expanded(
              child: Text(roomTitle(room, user?.displayName, widget.join)),
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
              // Review because without this, drawer may need to
              // load a bit of time.
              // This will help room to load instantly upon opening the room
              onLoading: ChatRoomMenuDrawer(
                room: room,
                user: user,
              ),
              builder: (room) {
                return ChatRoomMenuDrawer(
                  room: room,
                  user: user,
                );
              },
            )
          : null,
      body: room == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : GestureDetector(
              // Purpose: To remove the keyboard when user is reading
              //          on the chat messages (when user taps the messages).
              //
              // Why: In iPhone Device, user must have a way to toggle off the
              //      keyboard itself.
              //
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ChatMessagesListView(
                        room: room!,
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: ChatRoomInputBox(
                      room: room!,
                    ),
                  ),
                ],
              ),
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
          photoUrl: user!.photoUrl,
          initials: user!.displayName.or(user!.uid),
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
                dog("Error with an Image in Chat Room Screen(chat.room.screen.dart): $error");
                return const Icon(Icons.error);
              },
            )
          : isGroup
              ? Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                )
              : Center(
                  child: Text(
                    getOtherUserUidFromRoomId(widget.join!.roomId)!.characters.first.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                  ),
                ),
    );
  }
}
