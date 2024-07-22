import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomInputBox extends StatefulWidget {
  const ChatRoomInputBox({
    super.key,
    this.room,
  });

  final ChatRoom? room;

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

  sendMessage() {
    dog("sending message");
    if (controller.text.isEmpty) return;

    // TODO revise
    ChatMessage.create(
      roomId: widget.room!.id,
      text: controller.text,
    );

    controller.clear();
    setState(() => submitable = false);
  }
}
