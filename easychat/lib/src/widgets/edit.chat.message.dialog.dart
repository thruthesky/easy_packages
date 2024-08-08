import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EditChatMessageDialog extends StatefulWidget {
  const EditChatMessageDialog({
    super.key,
    required this.message,
    required this.room,
  });

  final ChatMessage message;
  final ChatRoom room;

  @override
  State<EditChatMessageDialog> createState() => _EditChatMessageDialogState();
}

class _EditChatMessageDialogState extends State<EditChatMessageDialog> {
  TextEditingController textController = TextEditingController();
  FocusNode textFocus = FocusNode();

  ChatMessage get message => widget.message;
  BehaviorSubject<double?> uploadProgress = BehaviorSubject.seeded(null);

  String? url;

  double photoWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56 / 2;

  BorderSide? enabledBorderSide(BuildContext context) =>
      Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide;

  @override
  void initState() {
    super.initState();
    textController.text = message.text ?? '';
    url = message.url;
    textFocus.requestFocus();
  }

  @override
  void dispose() {
    textController.dispose();
    if (url != null && url != message.url) {
      // deletes the url if we uploaded but not saved
      StorageService.instance.delete(url);
      dog("[Edit Message] Deleting unsaved image.");
    }
    textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Message"),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      value: snapshot.data as double,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            if (url != null && url!.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: photoWidth(context),
                  width: photoWidth(context),
                  margin: const EdgeInsets.only(bottom: 12),
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
                            setState(() {
                              url = '';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Container(
              decoration: BoxDecoration(
                border:
                    Theme.of(context).inputDecorationTheme.enabledBorder != null
                        ? Border.all(
                            color: enabledBorderSide(context)?.color ??
                                const Color(0xFF000000),
                            width: enabledBorderSide(context)?.width ?? 1.0,
                            style: enabledBorderSide(context)?.style ??
                                BorderStyle.solid,
                          )
                        : Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: textController,
                focusNode: textFocus,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  prefixIcon: ImageUploadIconButton(
                    progress: (prog) => uploadProgress.add(prog),
                    complete: () => uploadProgress.add(null),
                    onUpload: (url) async {
                      if (this.url != null && this.url != message.url) {
                        // let message.update() handle deleting the
                        // original image. Delete only others that are replaced.
                        dog("[Edit Message] Deleting replaced image.");
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
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if ((url == null || url.isEmpty) && textController.text.isEmpty) {
              final re = await confirm(
                context: context,
                title: const Text("Empty Message"),
                message: const Text(
                  "Saving empty message. Do you want to delete the message instead?",
                ),
              );
              if (re == true) {
                await message.delete();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
              return;
            }

            final List<Future> futures = [
              // Should delete the old url if it is different.
              if (message.url != url && url != null && message.url != null)
                StorageService.instance.delete(message.url!).then(
                  (v) {
                    dog("[Edit Message] Deleted original image.");
                  },
                ),
              ChatService.instance.updateMessage(
                message: message,
                text: textController.text.trim(),
                url: url,
                isEdit: true,
              )
            ];
            // This will prevent deleting the new photo
            url = null;
            Navigator.of(context).pop();
            // If error occured here check the futures.
            await Future.wait(futures);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
