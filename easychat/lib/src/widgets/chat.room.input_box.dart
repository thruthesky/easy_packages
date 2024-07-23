import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
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
  double? uploadProgress;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 8, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageUploadIconButton(
                onUpload: (url) async {
                  uploadProgress = 0;
                  setState(() {});
                  await sendMessage(photoUrl: url);
                },
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
        ],
      ),
    );
  }

  Future sendMessage({String? photoUrl}) async {
    dog("sending message");
    if (controller.text.isEmpty && photoUrl == null) return;

    await shouldAcceptInvitation();

    List<Future> futures = [
      ChatMessage.create(
        roomId: widget.room!.id,
        text: controller.text,
        url: photoUrl,
      ),
      // TODO revise for photo url
      widget.room!.update(
        lastMessageText: controller.text,
        lastMessageAt: FieldValue.serverTimestamp(),
        lastMessageUid: my.uid,
        lastMessageUrl: photoUrl,
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
