import 'dart:async';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
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
  ChatRoom? $room;
  User? $user;

  StreamSubscription? roomSubscription;
  ValueNotifier<int> roomNotifier = ValueNotifier(0);

  bool isLoading = true;

  /// Reason: we are using room notifier to listen on updates
  ///         this means that when room is ready and user is joining
  ///         we have to wait for the ValueListenable to react on
  ///         the update on the room. At first The state will show
  ///         that user is not a member and can't show the message.
  ///         After short time, it will show the messages.
  ///
  /// I think this is important for UX and prevent people to be confused
  /// when joining into an open chat room and seeing a quick message
  /// flashing upon entering room.
  bool isJoiningNow = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    $room = widget.room;
    $user = widget.user;

    // Single chat.
    //
    // If room is null, user should not be null.
    // We have to get room from other user.
    if ($room == null) {
      // Create chat room if user is set.
      await loadOrCreateRoomForSingleChat();
    } else if ($user == null && $room!.single) {
      $user = await User.get(getOtherUserUidFromRoomId($room!.id)!);
    }

    await onRoomReady();
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  bool get shouldJoinOpenGroupChat =>
      !$room!.userUids.contains(myUid) && $room!.open && $room!.group;

  bool get shouldJoinSingleChat =>
      !$room!.userUids.contains(myUid) &&
      $room!.single &&
      $room!.uidsFromRoomId.contains(myUid) &&
      !$room!.invitedUsers.contains(myUid) &&
      !$room!.rejectedUsers.contains(myUid);

  onRoomReady() async {
    if ($room == null) return;
    if ($room!.blockedUsers.contains(myUid)) return;
    // Auto Join Groups when it is open chat
    if (shouldJoinOpenGroupChat || shouldJoinSingleChat) {
      isJoiningNow = true;
      await $room!.join();
    }
    roomSubscription ??=
        ChatService.instance.roomCol.doc($room!.id).snapshots().listen(
      (doc) {
        $room!.copyFromSnapshot(doc);
        $room!.updateMyReadMeta();
        roomNotifier.value = $room!.updatedAt.millisecondsSinceEpoch;
      },
    );
  }

  @override
  dispose() {
    roomSubscription?.cancel();
    roomNotifier.dispose();
    super.dispose();
  }

  Future<void> loadOrCreateRoomForSingleChat() async {
    $room = await ChatRoom.get(singleChatRoomId($user!.uid));

    if ($room != null) return;
    await createAndLoadSingleChat();
  }

  Future<void> createAndLoadSingleChat() async {
    final newRoomRef = await ChatRoom.createSingle($user!.uid);
    $room = await ChatRoom.get(newRoomRef.id);
  }

  String title(ChatRoom? room) {
    if ($user != null) {
      return $user!.displayName.or('no name'.t);
    }
    // Single chat or group chat can have name.
    if ((room?.name ?? "").trim().isNotEmpty) {
      return room!.name;
    }
    return 'chat room'.t;
  }

  bool get iAmInvited => $room?.invitedUsers.contains(myUid!) ?? false;
  bool get iRejected => $room?.rejectedUsers.contains(myUid!) ?? false;

  String notMemberMessage(ChatRoom? room) {
    if (iAmInvited) {
      return 'unaccepted yet, accept before reading message'.t;
    }
    if (iRejected) {
      return 'the chat was rejected, unable to show message'.t;
    }
    if (isJoiningNow) {
      return 'please wait'.t;
    }
    // Else, it should be handled by the Firestore rulings.
    return 'the chat room may be private or deleted'.t;
  }

  String notMemberTitle(ChatRoom? room) {
    if (iAmInvited) {
      return "chat invitation".t;
    }
    if (iRejected) {
      return 'rejected chat'.t;
    }
    if (isJoiningNow) {
      return 'loading'.t;
    }
    // Else, it should be handled by the Firestore rulings.
    return 'unable to chat'.t;
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
  bool get canViewChatMessage {
    return (($room == null && $user != null) || $room?.joined == true) &&
        $room?.blockedUsers.contains(myUid) != true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: roomNotifier,
          builder: (_, hc, __) => !canViewChatMessage
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    if ($user != null || $room!.single) ...[
                      GestureDetector(
                        child: UserAvatar(
                          user: $user!,
                          size: 36,
                          radius: 15,
                        ),
                        onTap: () =>
                            UserService.instance.showPublicProfileScreen(
                          context,
                          user: $user!,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ] else if ($room!.group) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        width: 36,
                        height: 36,
                        clipBehavior: Clip.hardEdge,
                        child:
                            $room!.iconUrl != null && $room!.iconUrl!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: $room!.iconUrl!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      dog("Error in Image Chat Room Screen: $error");
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : Icon(
                                    Icons.people,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(title($room)),
                    ),
                  ],
                ),
        ),
        actions: [
          if (ChatService.instance.chatRoomActionButton != null &&
              $room != null)
            ChatService.instance.chatRoomActionButton!($room!),
          ValueListenableBuilder(
            valueListenable: roomNotifier,
            builder: (context, hc, child) {
              if (!canViewChatMessage) return const SizedBox.shrink();
              return DrawerButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          )
        ],
      ),
      endDrawer: ValueListenableBuilder(
        valueListenable: roomNotifier,
        builder: (_, hc, __) {
          if (!canViewChatMessage) return const SizedBox.shrink();
          return ChatRoomMenuDrawer(
            room: $room,
            user: $user,
          );
        },
      ),
      body:
          // showing loading widget at first because the user must join
          // the room first.
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ValueListenableBuilder(
                  valueListenable: roomNotifier,
                  builder: (_, hc, __) {
                    if (!canViewChatMessage) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: Center(
                          child: AlertDialog(
                            title: Text(notMemberTitle($room)),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (iAmInvited &&
                                    $room?.single == true &&
                                    $user != null) ...[
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => UserService.instance
                                        .showPublicProfileScreen(context,
                                            user: $user!),
                                    child: Row(
                                      children: [
                                        UserAvatar(user: $user!),
                                        const SizedBox(width: 12),
                                        Column(
                                          children: [
                                            Text(
                                                $user!.displayName
                                                    .or('no name'.t),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge),
                                            if ($user!.stateMessage != null &&
                                                $user!.stateMessage!
                                                    .isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text($user!.stateMessage!),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    notMemberMessage($room),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                if (iAmInvited) ...[
                                  const SizedBox(height: 48),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await $room!.acceptInvitation();
                                            if (!context.mounted) return;
                                            setState(() {});
                                          },
                                          child: Text("accept".t),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await $room!.rejectInvitation();
                                          },
                                          child: Text("reject".t),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    isJoiningNow = false;
                    return Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ChatMessagesListView(
                              key: const ValueKey("Chat Message List View"),
                              room: $room!,
                            ),
                          ),
                        ),
                        SafeArea(
                          top: false,
                          child: ChatRoomInputBox(
                            room: $room!,
                            onSend: (text, photoUrl, replyTo) {
                              mayInviteOtherUser();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  /// Ivite the other user in 1:1 chat
  ///
  /// Invite the other user if the other user is not invited yet.
  /// This is only for single chat.
  ///
  /// Refer README.md for more information.
  mayInviteOtherUser() {
    //
    if ($room!.group) return;
    if ($room!.userUids.length == 2) return;

    // return if the user has already invited or rejected.
    final otherUserUid = getOtherUserUidFromRoomId($room!.id)!;
    if ($room!.rejectedUsers.contains(otherUserUid)) return;
    if ($room!.invitedUsers.contains(otherUserUid)) return;

    //
    $room!.inviteUser(otherUserUid);
  }
}
