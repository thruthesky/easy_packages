import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easychat/src/widgets/chat.room.input_box.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    this.room,
    this.user,
  });

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
    _initTest();
  }

  _initTest() async {
    user = await User.get("LOsnkgH83yYhazzPA3ZAXjjIgnM2", cache: false);
    final roomId = singleChatRoomId(user!.uid);
    room = await ChatRoom.get(roomId);

    if (room == null) {
      final roomRef = await ChatRoom.createSingle(user!.uid);
      room = await ChatRoom.get(roomRef.id);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.displayName ?? 'Chat Room'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: room?.messageRef != null
                ? FirebaseDatabaseListView(
                    query: room!.messageRef.orderByChild("order"),
                    reverse: true,
                    itemBuilder: (context, doc) {
                      final message = ChatMessage.fromSnapshot(doc);
                      dog("message.uid == my.uid ${message.uid} == ${user!.uid}");
                      return ListTile(
                        title: Align(
                          alignment: message.uid == my.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(message.id),
                        ),
                        subtitle: Align(
                          alignment: message.uid == my.uid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(message.text!),
                        ),
                      );
                    },
                  )
                : const Text('Please wait'),
          ),
          SafeArea(
            child: ChatRoomInputBox(
              room: room,
            ),
          ),
        ],
      ),
    );
  }
}
