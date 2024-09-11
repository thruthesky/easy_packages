import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat Room Edit Screen
///
/// This is the screen for creating and updating chat rooms.
class ChatRoomEditScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomEdit';
  const ChatRoomEditScreen({
    super.key,
    this.room,
    this.defaultOpen = false,
  });

  final ChatRoom? room;
  final bool defaultOpen;

  @override
  State<ChatRoomEditScreen> createState() => _ChatRoomEditScreenState();
}

class _ChatRoomEditScreenState extends State<ChatRoomEditScreen> {
  ChatRoom? get room => widget.room;
  bool get isCreate => widget.room == null;
  bool get isUpdate => widget.room != null;

  bool open = false;
  bool allMembersCanInvite = false;
  bool isLoading = false;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? iconUrl;

  @override
  void initState() {
    super.initState();
    if (isCreate) {
      open = widget.defaultOpen;
      return;
    }
    nameController.text = room!.name;
    descriptionController.text = room!.description;

    open = room?.open ?? false;
    allMembersCanInvite = room!.allMembersCanInvite;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    if (iconUrl != null && iconUrl != room?.iconUrl) {
      // delete if something was uploaded but not saved
      StorageService.instance.delete(iconUrl);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? 'chat room create'.t : 'chat room update'.t),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'enter room name'.t,
                  helperText: 'you can change this chat room name later'.t,
                  label: Text('group chat name'.t),
                ),
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'enter description'.t,
                  label: Text('description'.t),
                  helperText: 'this is chat room description'.t,
                ),
                controller: descriptionController,
              ),
            ),
            const SizedBox(height: 36),
            // NOTE: If Image is uploaded, it is automatically saved
            //       However, chat room will be reactive if updatedAt is
            //       changed. Using ImageUploadCard won't update it.
            ImageUploadCard(
              initialData: room?.iconUrl,
              onUpload: (url) {
                if (iconUrl != null && room?.iconUrl != iconUrl) {
                  // This means the photo before saving is being
                  // replaced. Must delete the previous one.
                  StorageService.instance.delete(iconUrl);
                }
                setState(() {
                  iconUrl = url;
                });
              },
            ),

            //
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 0, 0),
              child: CheckboxListTile(
                title: Text('open chat'.t),
                subtitle: Text('anyone can join this chat room'.t),
                value: open,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    open = value;
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 0, 0),
              child: CheckboxListTile(
                // When it is open group, basically all members can invite
                enabled: !open,
                title: Text('members can invite'.t),
                subtitle: Text('all members can invite others to join'.t),
                value: open ? true : allMembersCanInvite,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    allMembersCanInvite = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            if (isLoading) ...[
              const CircularProgressIndicator(),
            ] else
              isCreate
                  ? ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        ChatRoom? chatRoom;
                        try {
                          final newRoomRef = await ChatRoom.create(
                            name: nameController.text,
                            description: descriptionController.text,
                            iconUrl: iconUrl,
                            open: open,
                            group: true,
                            single: false,
                            users: {myUid!: false},
                          );
                          chatRoom = await ChatRoom.get(newRoomRef.key!);
                          await ChatService.instance.join(
                            chatRoom!,
                            protocol: ChatProtocol.create,
                          );
                        } catch (e) {
                          dog("Error ${e.toString()}");
                          setState(() {
                            isLoading = false;
                          });
                          rethrow;
                        }
                        // This will prevent the newly Uploaded photo to be deleted
                        iconUrl = null;
                        if (!context.mounted) return;
                        Navigator.of(context).pop(chatRoom.ref);
                        ChatService.instance
                            .showChatRoomScreen(context, room: chatRoom);
                      },
                      child: Text('create'.t.toUpperCase()),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await room!.update(
                            name: nameController.text,
                            description: descriptionController.text,
                            open: open,
                            iconUrl: iconUrl,
                            allMembersCanInvite: allMembersCanInvite,
                          );
                          if (iconUrl != room!.iconUrl) {
                            // delete the old icon url
                            StorageService.instance.delete(room!.iconUrl);
                          }
                          // This will prevent the newly Uploaded photo to be deleted
                          iconUrl = null;
                          if (!context.mounted) return;
                          Navigator.of(context).pop(room!.ref);
                        } catch (e) {
                          dog("Error ${e.toString()}");
                          setState(() {
                            isLoading = false;
                          });
                          rethrow;
                        }
                      },
                      child: Text('update'.t.toUpperCase()),
                    ),
            const SafeArea(
              child: SizedBox(
                height: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
