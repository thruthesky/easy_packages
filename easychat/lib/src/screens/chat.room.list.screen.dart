import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatefulWidget {
  const ChatRoomListScreen({
    super.key,
    this.single,
    this.group,
    this.open,
  }) : assert(
            (single == true) ^ (group == true) ^ (open == true) ||
                (single == null && group == null && open == null),
            'Only one of single, group, or open can be true.');

  /// If true, will list only single chats
  final bool? single;

  /// If true, will list only group chats
  final bool? group;

  /// If true, will list only open chats
  final bool? open;

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  bool? single;
  bool? group;
  bool? open;

  String currentOption = _allMyChats;

  static const String _allMyChats = 'allMyChats';
  static const String _singleChats = 'singleChats';
  static const String _groupChats = 'groupChats';
  static const String _openChats = 'openChats';

  static const List<String> _options = [
    _allMyChats,
    _singleChats,
    _groupChats,
    _openChats,
  ];

  @override
  void initState() {
    super.initState();
    single = widget.single;
    group = widget.group;
    open = widget.open;
    currentOption = single == true
        ? _singleChats
        : group == true
            ? _groupChats
            : open == true
                ? _openChats
                : _allMyChats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat room list screen title: $currentOption'.t),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showChatRoomEditScreen(
                context,
                defaultOpen: currentOption == _openChats,
              );
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.settings),
            onSelected: (q) {
              setState(() {
                currentOption = q;
                single = q == _singleChats;
                group = q == _groupChats;
                open = q == _openChats;
              });
            },
            constraints: const BoxConstraints(
              maxWidth: 180,
            ),
            itemBuilder: (BuildContext context) {
              return _options
                  .map(
                    (String option) => PopupMenuItem<String>(
                      value: option,
                      child: Text("chat room list screen option: $option".t),
                    ),
                  )
                  .toList();
            },
          ),
        ],
      ),
      body: AuthStateChanges(
        builder: (user) {
          if (user == null || user.isAnonymous) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("must login to chat".t),
                  if (ChatService.instance.loginButtonBuilder != null)
                    ChatService.instance.loginButtonBuilder!(context),
                ],
              ),
            );
          }
          return ChatRoomListView(
            single: single,
            group: group,
            open: open,
            itemBuilder: (context, join, index) {
              return ChatRoomListTile(
                join: join,
              );
            },
          );
        },
      ),
    );
  }
}
