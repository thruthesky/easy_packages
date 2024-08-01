import 'dart:async';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChatRoomInputBox extends StatefulWidget {
  const ChatRoomInputBox({
    super.key,
    required this.room,
  });

  final ChatRoom room;

  @override
  State<ChatRoomInputBox> createState() => _ChatRoomInputBoxState();
}

class _ChatRoomInputBoxState extends State<ChatRoomInputBox> {
  final TextEditingController controller = TextEditingController();

  bool submitable = false;
  BehaviorSubject<double?> uploadProgress = BehaviorSubject.seeded(null);

  ChatRoom get room => widget.room;

  @override
  void dispose() {
    uploadProgress.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<double?>(
          initialData: uploadProgress.value,
          stream: uploadProgress,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: LinearProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              debugPrint("Error: ${snapshot.error}");
              return Text("Error: ${snapshot.error}");
            }
            if (snapshot.data != null) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: LinearProgressIndicator(
                  value: snapshot.data,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 8, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageUploadIconButton(
                progress: (prog) => uploadProgress.add(prog),
                complete: () => uploadProgress.add(null),
                onUpload: (url) async {
                  await ChatService.instance.sendMessage(
                    room,
                    photoUrl: url,
                  );
                },
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (submitable == value.isNotEmpty) return;
                    setState(() => submitable = value.isNotEmpty);
                  },
                  onSubmitted: (value) => sendTextMessage(value),
                ),
              ),
              IconButton(
                onPressed:
                    submitable ? () => sendTextMessage(controller.text) : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future sendTextMessage(String text) async {
    if (text.isNotEmpty) controller.clear();
    setState(() => submitable = false);
    await ChatService.instance.sendMessage(
      room,
      text: text,
    );
  }
}
