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
  final Function(BuildContext context, ChatRoom updatedRoom)? afterAccept;

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
                    sendMessage(text: value);
                  },
                ),
              ),
              IconButton(
                onPressed: () => submitable
                    ? sendMessage(
                        text: controller.text,
                      )
                    : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future sendMessage({String? photoUrl, String? text}) async {
    if ((text ?? "").isEmpty && photoUrl == null) return;
    await shouldAcceptInvitation();
    List<Future> futures = [
      ChatMessage.create(
        roomId: widget.room!.id,
        text: text,
        url: photoUrl,
      ),
      widget.room!.updateUnreadUsers(
        lastMessageText: text,
        lastMessageUrl: photoUrl,
      ),
    ];
    if (text != null) controller.clear();
    setState(() => submitable = false);
    await Future.wait(futures);
  }

  shouldAcceptInvitation() async {
    if (widget.room == null) return;
    if (widget.room!.userUids.contains(my.uid)) return;
    if (widget.room!.invitedUsers.contains(my.uid)) {
      await widget.room!.acceptInvitation();
      widget.room!.invitedUsers.remove(my.uid);
      if (widget.afterAccept == null) return;
      final updatedRoom = await ChatRoom.get(widget.room!.id);
      if (updatedRoom == null) return;
      if (!mounted) return;
      widget.afterAccept?.call(context, updatedRoom);
      return;
    }
    throw "chat-room/uninvited-chat You can only send a message to a chat room where you are a member or an invited user.";
  }
}
