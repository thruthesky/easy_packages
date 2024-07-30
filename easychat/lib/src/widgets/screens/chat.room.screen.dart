import 'dart:async';

import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easychat/src/widgets/chat.messages.list_view.dart';
import 'package:easychat/src/widgets/chat.room.input_box.dart';
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
  ChatRoom? room;
  User? user;

  Stream? roomStream;
  Widget? chatMessagesWidget;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    user = widget.user;
    init();
  }

  init() async {
    // If room is null, user should not be null.
    // We have to get room from other user.
    if (room == null) await getRoomFromOtherUser();
    roomStream = room?.ref.snapshots();
    if (room!.single && user == null) await getOtherUser();
    if (!mounted) return;
    room!.read();
    setState(() {});
  }

  Future<void> getRoomFromOtherUser() async {
    room = await ChatRoom.get(singleChatRoomId(user!.uid));
    if (room != null) return;
    // In case the room doesn't exists, we create the room.
    // Automatically this will invite the other user.
    // The other user wont normally see the message in chat room
    // list. However the other user may see the messages if the
    // other user opens the chat room.
    final newRoomRef = await ChatRoom.createSingle(user!.uid);
    room = await ChatRoom.get(newRoomRef.id);
  }

  Future<void> getOtherUser() async {
    user = await User.get(getOtherUserUidFromRoomId(room!.id)!, cache: false);
  }

  String get title {
    if (room != null && room!.name.trim().isNotEmpty) {
      return room!.name;
    }
    if (user != null) {
      return user!.displayName.trim().isNotEmpty
          ? user!.displayName
          : user!.uid;
    }
    return 'Chat Room';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (room?.userUids.contains(my.uid) ?? false)
            StreamBuilder(
                stream: roomStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    room = ChatRoom.fromSnapshot(snapshot.data);
                  }
                  return IconButton(
                    onPressed: () {
                      if (room == null) return;
                      ChatService.instance
                          .showChatRoomMenuScreen(context, room!);
                    },
                    icon: const Icon(Icons.more_vert),
                  );
                }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // There is a chance for user to open the chat room
          // if the user is not a member of the chat room
          if (!(room?.userUids.contains(my.uid) ?? true)) ...[
            // The user has a chance to open the chat room with message
            // when the other user sent a message (1:1) but the user
            // haven't accepted yet.
            if (room?.invitedUsers.contains(my.uid) ?? false)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "You haven't accepted this chat yet. Once you send a message, the chat is automatically accepted.",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              )
            // For open chat rooms, the rooms can be seen by users.
            else if (room?.group ?? false)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "This is an open group. Once you sent a message, you will automatically join the group.",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            // Else, it should be handled by the Firestore rulings.
          ],
          if (room != null)
            chatMessagesWidget ??= Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ChatMessagesListView(room: room!),
              ),
            )
          else
            const Spacer(),
          SafeArea(
            top: false,
            child: ChatRoomInputBox(
              room: room,
              afterAccept: (context, room) {
                if (!mounted) return;
                setState(
                  () {
                    this.room = room;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
