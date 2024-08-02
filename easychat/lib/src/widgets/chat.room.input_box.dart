import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
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

  bool get canSubmit => controller.text.isNotEmpty || url != null;
  bool submitable = false;
  BehaviorSubject<double?> uploadProgress = BehaviorSubject.seeded(null);
  ChatRoom get room => widget.room;

  String? url;

  double photoWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56;

  @override
  void dispose() {
    uploadProgress.close();
    controller.dispose();
    if (url != null) {
      StorageService.instance.delete(url);
    }
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
          child: Column(
            children: [
              if (url != null) ...[
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: url!,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          StorageService.instance.delete(url);
                          setState(() {
                            url = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: ImageUploadIconButton(
                          progress: (prog) => uploadProgress.add(prog),
                          complete: () => uploadProgress.add(null),
                          onUpload: (url) async {
                            setState(() {
                              submitable = canSubmit;
                              this.url = url;
                            });
                          },
                        ),
                        suffixIcon: IconButton(
                          onPressed:
                              submitable ? () => sendTextMessage() : null,
                          icon: const Icon(Icons.send),
                        ),
                      ),
                      onChanged: (value) {
                        if (submitable == canSubmit) return;
                        setState(() => submitable = canSubmit);
                      },
                      onSubmitted: (value) => sendTextMessage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future sendTextMessage() async {
    if (controller.text.isEmpty && url == null) return;
    setState(() => submitable = false);
    final sendMessageFuture = ChatService.instance.sendMessage(
      room,
      text: controller.text,
      photoUrl: url,
    );
    url = null;
    if (controller.text.isNotEmpty) controller.clear();
    await sendMessageFuture;
  }
}
