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
      MediaQuery.of(context).size.width * 0.56 / 2;

  BorderSide? enabledBorderSide(BuildContext context) =>
      Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide;

  double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56;

  @override
  void initState() {
    super.initState();
    room.initReply();
  }

  @override
  void dispose() {
    uploadProgress.close();
    controller.dispose();
    room.disposeReply();
    if (url != null) {
      StorageService.instance.delete(url);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: room.replyValueNotifier!,
          builder: (context, message, child) {
            if (message != null) {
              return ChatRoomReplyingTo(
                replyTo: message,
              );
            }
            return const SizedBox.shrink();
          },
        ),
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
                  value: snapshot.data as double,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Container(
          decoration: BoxDecoration(
            border: Theme.of(context).inputDecorationTheme.enabledBorder != null
                ? Border.all(
                    color: enabledBorderSide(context)?.color ??
                        const Color(0xFF000000),
                    width: enabledBorderSide(context)?.width ?? 1.0,
                    style:
                        enabledBorderSide(context)?.style ?? BorderStyle.solid,
                  )
                : Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (url != null) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: photoWidth(context),
                    width: photoWidth(context),
                    margin: const EdgeInsets.all(12),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: url!,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            color: Theme.of(context).colorScheme.onError,
                            icon: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.close),
                            ),
                            onPressed: () {
                              StorageService.instance.delete(url);
                              setState(
                                () {
                                  url = null;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: controller,
                        maxLines: 2,
                        minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: ImageUploadIconButton(
                            progress: (prog) => uploadProgress.add(prog),
                            complete: () => uploadProgress.add(null),
                            onUpload: (url) async {
                              if (this.url != null) {
                                // This means the photo before sending is being
                                // replaced. Must delete the previous one.
                                StorageService.instance.delete(this.url);
                              }
                              if (!mounted) {
                                // We should delete the uploaded url if the user
                                // suddenly went back while it is still uploading.
                                StorageService.instance.delete(url);
                                return;
                              }
                              setState(() {
                                this.url = url;
                                submitable = canSubmit;
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
      text: controller.text.trim(),
      photoUrl: url,
      replyTo: room.replyValueNotifier!.value,
    );
    url = null;
    if (room.replyValueNotifier!.value != null) clearReplyTo();
    if (controller.text.isNotEmpty) controller.clear();
    await sendMessageFuture;
  }

  void clearReplyTo() {
    room.replyValueNotifier!.value = null;
  }
}
