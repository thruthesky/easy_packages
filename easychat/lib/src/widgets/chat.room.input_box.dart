import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatRoomInputBox extends StatefulWidget {
  const ChatRoomInputBox({
    super.key,
    this.room,
    this.afterAccept,
  });

  final ChatRoom? room;
  final Function()? afterAccept;

  @override
  State<ChatRoomInputBox> createState() => _ChatRoomInputBoxState();
}

class _ChatRoomInputBoxState extends State<ChatRoomInputBox> {
  final TextEditingController controller = TextEditingController();

  bool submitable = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.camera_alt),
          ),
          Expanded(
            child: TextField(
              enabled: widget.room != null,
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (submitable == value.isNotEmpty) return;
                setState(() => submitable = value.isNotEmpty);
              },
              onSubmitted: (value) {
                sendMessage();
              },
            ),
          ),
          IconButton(
            onPressed: submitable ? sendMessage : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  sendMessage() async {
    dog("sending message");
    if (controller.text.isEmpty) return;

    await shouldAcceptInvitation();

    List<Future> futures = [
      ChatMessage.create(
        roomId: widget.room!.id,
        text: controller.text,
      ),
      // TODO revise for photo url
      widget.room!.update(
        lastMessageText: controller.text,
        lastMessageAt: FieldValue.serverTimestamp(),
        lastMessageUid: my.uid,
      ),
    ];

    controller.clear();
    setState(() => submitable = false);
    await Future.wait(futures);
  }

  shouldAcceptInvitation() async {
    if (widget.room == null) return;
    if (widget.room!.users.contains(my.uid)) return;
    if (widget.room!.invitedUsers.contains(my.uid)) {
      await widget.room!.acceptInvitation();
      widget.room!.users.add(my.uid);
      widget.room!.invitedUsers.remove(my.uid);
      widget.afterAccept?.call();
      return;
    }
    throw "chat-room/uninvited-chat You can only send a message to a chat room where you are a member or an invited user.";
  }
}
