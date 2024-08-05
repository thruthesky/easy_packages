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
  });

  final ChatRoom? room;

  @override
  State<ChatRoomEditScreen> createState() => _ChatRoomEditScreenState();
}

class _ChatRoomEditScreenState extends State<ChatRoomEditScreen> {
  ChatRoom? get room => widget.room;
  bool get isCreate => widget.room == null;
  bool get isUpdate => widget.room != null;

  bool open = false;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String? iconUrlOnCreate;

  @override
  void initState() {
    super.initState();
    if (isCreate) return;
    nameController.text = room!.name;
    descriptionController.text = room!.description;
    open = room!.open;
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
        title: Text(isCreate ? 'Chat Room Create' : 'Chat Room Update'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Input room name',
                  helperText:
                      'This is the chat room name. You can change it later.',
                  label: Text('Name'),
                ),
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Input description',
                  label: Text('Description'),
                  helperText: 'This is the chat room description.',
                ),
                controller: descriptionController,
              ),
            ),
            const SizedBox(height: 36),
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
                title: const Text('Open Chat'),
                subtitle: const Text('Anyone can join this chat room.'),
                value: open,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    open = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            isCreate
                ? ElevatedButton(
                    onPressed: () async {
                      final newRoomRef = await ChatRoom.create(
                        name: nameController.text,
                        description: descriptionController.text,
                        iconUrl: iconUrlOnCreate,
                        open: open,
                        group: true,
                        single: false,
                        users: [my.uid],
                      );
                      final chatRoom = await ChatRoom.get(newRoomRef.id);
                      iconUrlOnCreate = null;
                      if (!context.mounted) return;
                      Navigator.of(context).pop(chatRoom!.ref);
                      ChatService.instance
                          .showChatRoomScreen(context, room: chatRoom);
                    },
                    child: const Text('CREATE'),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await room!.update(
                        name: nameController.text,
                        description: descriptionController.text,
                        open: open,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop(room!.ref);
                    },
                    child: const Text('UPDATE'),
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
