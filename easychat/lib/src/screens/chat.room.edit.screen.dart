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

  String? iconUrlOnCreate;

  @override
  void initState() {
    super.initState();
    if (isCreate) {
      open = widget.defaultOpen;
      return;
    }
    nameController.text = room!.name;
    descriptionController.text = room!.description;

    open = room!.open;
    allMembersCanInvite = room!.allMembersCanInvite;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    if (isCreate && iconUrlOnCreate != null) {
      StorageService.instance.delete(iconUrlOnCreate);
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
              ref: room?.ref,
              field: room?.ref != null ? "iconUrl" : null,
              onUpload: isCreate
                  ? (url) {
                      setState(() {
                        iconUrlOnCreate = url;
                      });
                    }
                  : null,
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
                title: Text('members can invite'.t),
                subtitle: Text('all members can invite others to join'.t),
                value: allMembersCanInvite,
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
                            iconUrl: iconUrlOnCreate,
                            open: open,
                            group: true,
                            single: false,
                            users: [myUid!],
                          );
                          chatRoom = await ChatRoom.get(newRoomRef.id);
                        } catch (e) {
                          dog("Error ${e.toString()}");
                          setState(() {
                            isLoading = false;
                          });
                          rethrow;
                        }
                        if (chatRoom == null) return;
                        iconUrlOnCreate = null;
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
                            allMembersCanInvite: allMembersCanInvite,
                          );
                        } catch (e) {
                          dog("Error ${e.toString()}");
                          setState(() {
                            isLoading = false;
                          });
                          rethrow;
                        }
                        if (!context.mounted) return;
                        Navigator.of(context).pop(room!.ref);
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
