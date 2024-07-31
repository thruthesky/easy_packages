import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.room.user.dart';
import 'package:easychat/src/widgets/chat.room.list_tile.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

enum ChatRoomListOption {
  allMine,
  allMineByTime,
  open,
  single,
  singleByTime,
  group,
  groupByTime,
}

class ChatRoomListView extends StatelessWidget {
  const ChatRoomListView({
    super.key,
    required this.queryOption,
  });

  final ChatRoomListOption queryOption;

  Query get query {
    Query q = ChatService.instance.roomCol;
    if (queryOption == ChatRoomListOption.allMine) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.order}',
        descending: true,
      );
    } else if (queryOption == ChatRoomListOption.allMineByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.timeOrder}',
        descending: true,
      );
    } else if (queryOption == ChatRoomListOption.open) {
      q = q
          .where(ChatRoom.field.open, isEqualTo: true)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    } else if (queryOption == ChatRoomListOption.single) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.singleOrder}',
        descending: true,
      );
    } else if (queryOption == ChatRoomListOption.singleByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.singleTimeOrder}',
        descending: true,
      );
    } else if (queryOption == ChatRoomListOption.group) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.groupOrder}',
        descending: true,
      );
    } else if (queryOption == ChatRoomListOption.groupByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.${my.uid}.${ChatRoomUser.field.groupTimeOrder}',
        descending: true,
      );
    }
    return q;
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
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
    );
  }
}
