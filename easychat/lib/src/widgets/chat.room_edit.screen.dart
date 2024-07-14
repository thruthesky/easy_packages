import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Chat Room Edit Screen
///
/// This is the screen for creating and updating chat rooms.
class ChatRoomEditScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomEdit';
  const ChatRoomEditScreen({super.key, this.room});

  final ChatRoom? room;

  @override
  State<ChatRoomEditScreen> createState() => _ChatRoomEditScreenState();
}

class _ChatRoomEditScreenState extends State<ChatRoomEditScreen> {
  ChatRoom get room => widget.room!;
  bool get isCreate => widget.room == null;
  bool get isUpdate => widget.room != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? 'Chat Room Create' : 'Chat Room Update'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Input room name',
                helperText:
                    'This is the chat room name. You can change it later.',
                label: Text('Name'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Input description',
                label: Text('Description'),
                helperText: 'This is the chat room description.',
              ),
            ),
          ),

          /// Chat room icon upload
          const UploadImage(),

          ///
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 0, 0),
            child: CheckboxListTile(
                title: const Text('Open Chat'),
                subtitle: const Text('Anyone can join this chat room.'),
                value: true,
                onChanged: (value) {}),
          ),
        ],
      ),
    );
  }
}
