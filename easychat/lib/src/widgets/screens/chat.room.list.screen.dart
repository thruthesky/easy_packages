import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomList';
  const ChatRoomListScreen({
    super.key,
    this.queryOption = ChatRoomListOption.allMine,
  });

  final ChatRoomListOption queryOption;

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  late ChatRoomListOption queryOption;
  @override
  void initState() {
    super.initState();
    queryOption = widget.queryOption;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room List: ${queryOption.name}'),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showChatRoomEditScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.settings),
            onSelected: (q) {
              setState(() {
                queryOption = q;
              });
            },
            itemBuilder: (BuildContext context) {
              return ChatRoomListOption.values
                  .map((q) => PopupMenuItem(value: q, child: Text(q.name)))
                  .toList();
            },
          ),
        ],
      ),
      body: ChatRoomListView(queryOption: queryOption),
    );
  }
}
