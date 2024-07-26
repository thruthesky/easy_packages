import 'package:easy_helpers/easy_helpers.dart';
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
    init();
  }

  init() async {
    if (room == null) await getRoomFromOtherUser();
    if (room!.single && user == null) await getOtherUser();
    if (!mounted) return;
    room!.read();
    setState(() {});
  }

  getRoomFromOtherUser() async {
    room = await ChatRoom.get(singleChatRoomId(user!.uid));
    if (room != null) return;
    final newRoomRef = await ChatRoom.createSingle(user!.uid);
    room = await ChatRoom.get(newRoomRef.id);
  }

  getOtherUser() async {
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
    dog("room.messageRef: ${room?.messageRef}");
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (room?.userUids.contains(my.uid) ?? false)
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
