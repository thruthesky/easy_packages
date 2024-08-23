import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EditChatMessageDialog extends StatefulWidget {
  const EditChatMessageDialog({
    super.key,
    required this.message,
  });

  final ChatMessage message;

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
    }
    textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('edit message'.t),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.replyTo != null)
                ChatRoomReplyingTo(
                  replyTo: message.replyTo!,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  maxWidth: 165,
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
              TextField(
                controller: textController,
                focusNode: textFocus,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  prefixIcon: UploadIconButton.image(
                    progress: (prog) =>
                        mounted ? uploadProgress.add(prog) : null,
                    complete: () => mounted ? uploadProgress.add(null) : null,
                    onUpload: (url) async {
                      if (this.url != null && this.url != message.url) {
                        // let message.update() handle deleting the
                        // original image. Delete only others that are replaced.
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
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("cancel".t),
          ),
          ElevatedButton(
            onPressed: () async {
              if ((url == null || url.isEmpty) && textController.text.isEmpty) {
                final re = await confirm(
                  context: context,
                  title: Text('empty message'.t),
                  message: Text(
                    "saving empty message, confirm if delete instead".t,
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
                  StorageService.instance.delete(message.url!),
                message.update(
                  text: textController.text.trim(),
                  url: url,
                  isEdit: true,
                ),
              ];
              // This will prevent deleting the new photo
              url = null;
              Navigator.of(context).pop();
              // If error occured here check the futures.
              await Future.wait(futures);
            },
            child: Text("save".t),
          ),
        ],
      ),
    );
  }
}
