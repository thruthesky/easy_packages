import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easychat/src/widgets/chat.bubble.dart';
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

  @override
  void initState() {
    super.initState();
    room = widget.room;
    user = widget.user;
    getRoom();
  }

  getRoom() async {
    if (room != null) {
      if (room!.group) return;
      await getOtherUser();
      if (mounted) setState(() {});
      return;
    }
    final roomId = singleChatRoomId(user!.uid);
    room = await ChatRoom.get(roomId);
    if (room == null) {
      final roomRef = await ChatRoom.createSingle(user!.uid);
      room = await ChatRoom.get(roomRef.id);
    }
    await getOtherUser();
    if (mounted) setState(() {});
  }

  getOtherUser() async {
    if (user != null || room!.group) return;
    user ??= await User.get(getOtherUserUidFromRoomId(room!.id)!, cache: false);
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
          if (room?.users.contains(my.uid) ?? false)
            IconButton(
              onPressed: () {
                if (room == null) return;
                ChatService.instance.showChatRoomMenuScreen(context, room!);
              },
              icon: const Icon(Icons.more_vert),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!(room?.users.contains(my.uid) ?? true)) ...[
            if (!(room?.invitedUsers.contains(my.uid) ?? true))
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
                        "This is an open group. Once you sent a message, you will join the group.",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          Expanded(
            child: room?.messageRef != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: ChatMessagesListView(
                      room: room,
                      user: user,
                      itemBuilder: (context, message) {
                        return ChatBubble(
                          message: message,
                        );
                      },
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          SafeArea(
            top: false,
            child: ChatRoomInputBox(
              room: room,
              afterAccept: () {
                if (!mounted) return;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
