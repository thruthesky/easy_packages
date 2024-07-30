import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.room.user.dart';
import 'package:easychat/src/widgets/chat.room.list_tile.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

enum ChatRoomListQuery {
  allMine,
  allMineByTime,
  open,
  single,
  singleByTime,
  group,
  groupByTime,
}

class ChatRoomListScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomList';
  const ChatRoomListScreen({
    super.key,
    this.queryType = ChatRoomListQuery.allMine,
  });

  final ChatRoomListQuery queryType;

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  late ChatRoomListQuery _queryType;
  @override
  void initState() {
    super.initState();
    _queryType = widget.queryType;
  }

  Query get query {
    Query q = ChatService.instance.roomCol;
    if (_queryType == ChatRoomListQuery.allMine) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.order}',
        descending: true,
      );
    } else if (_queryType == ChatRoomListQuery.allMineByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.timeOrder}',
        descending: true,
      );
    } else if (_queryType == ChatRoomListQuery.open) {
      q = q
          .where(ChatRoom.field.open, isEqualTo: true)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    } else if (_queryType == ChatRoomListQuery.single) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.singleOrder}',
        descending: true,
      );
    } else if (_queryType == ChatRoomListQuery.singleByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.singleTimeOrder}',
        descending: true,
      );
    } else if (_queryType == ChatRoomListQuery.group) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.groupOrder}',
        descending: true,
      );
    } else if (_queryType == ChatRoomListQuery.groupByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.groupTimeOrder}',
        descending: true,
      );
    }
    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room List: ${_queryType.name}'),
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
                _queryType = q;
              });
            },
            itemBuilder: (BuildContext context) {
              return ChatRoomListQuery.values
                  .map((q) => PopupMenuItem(value: q, child: Text(q.name)))
                  .toList();
            },
          ),
        ],
      ),
      body: FirestoreListView(
        query: query,
        errorBuilder: (context, error, stackTrace) {
          dog('Something went wrong: $error');
          return Center(child: Text('Something went wrong: $error'));
        },
        itemBuilder: (context, doc) {
          final room = ChatRoom.fromSnapshot(doc);
          return ChatRoomListTile(
            room: room,
          );
        },
      ),
    );
  }
}
