import 'dart:async';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
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

  StreamSubscription? roomSubscription;
  ValueNotifier<int> roomNotifier = ValueNotifier(0);

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

    await onRoomReady();
    if (!mounted) return;
    setState(() {});
  }

  onRoomReady() async {
    if ($room == null) return;
    // Auto Join Groups when it is open chat
    if (!$room!.userUids.contains(myUid) && $room!.open && $room!.group) {
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
    // In case the room doesn't exists, we will create the room.
    // Automatically this will invite the other user.
  }

  String title(ChatRoom room) {
    // Single chat or gruop chat can have name.
    if (room.name.trim().isNotEmpty) {
      return room.name;
    }
    //
    if ($user != null) {
      return $user!.displayName.or('no name'.t);
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
    // Else, it should be handled by the Firestore rulings.
    return 'the chat room may be private or deleted'.t;
  }

  /// Returns true if the login user can view the chat messages.
  ///
  /// It check if
  /// - the user has already joined the chat room,
  ///   -- the user must joined the room even if it's open chat.
  ///
  bool get canViewChatMessage {
    return $room?.joined == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: roomNotifier,
          builder: (_, hc, __) => $room == null
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    if ($room!.group) ...[
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
                                : const Icon(Icons.people),
                      ),
                      const SizedBox(width: 12),
                    ] else if ($room!.single) ...[
                      if ($user != null)
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
                    ],
                    Expanded(
                      child: Text(title($room!)),
                    ),
                  ],
                ),
        ),
        actions: [
          if (ChatService.instance.chatRoomActionButton != null &&
              $room != null)
            ChatService.instance.chatRoomActionButton!($room!),
          Builder(
            builder: (context) {
              return DrawerButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
      ),
      endDrawer: ValueListenableBuilder(
        valueListenable: roomNotifier,
        builder: (_, hc, __) {
          return ChatRoomMenuDrawer(
            room: $room,
            user: $user,
          );
        },
      ),
      body:
          // for ($room!.open && !canViewChatMessage)
          // showing loading widget at first because the user must join
          // the room first.
          ($room == null && $user == null) ||
                  ($room != null && $room!.open && !canViewChatMessage)
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ValueListenableBuilder(
                  valueListenable: roomNotifier,
                  builder: (_, hc, __) {
                    if ($room == null && $user != null) {
                      // this will happen if this user will send a
                      // message for the first time.
                      // Upon sending the message, it will create
                      // a single chat room and invite the other user.
                      return Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "no message yet. can send a message.".t,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SafeArea(
                            top: false,
                            child: ChatRoomInputBox(
                              beforeSend: (_) async {
                                final newRoomRef =
                                    await ChatRoom.createSingle($user!.uid);
                                $room = await ChatRoom.get(newRoomRef.id);
                                await onRoomReady();
                                if (mounted) setState(() {});
                                return $room!;
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    if (!canViewChatMessage) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: Center(
                          child: AlertDialog(
                            title: Text("chat invitation".t),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(notMemberMessage($room)),
                                if (iAmInvited) ...[
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await $room!.acceptInvitation();
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
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
