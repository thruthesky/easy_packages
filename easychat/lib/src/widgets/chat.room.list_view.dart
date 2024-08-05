import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
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
    this.queryOption = ChatRoomListOption.allMine,
    this.itemBuilder,
    this.emptyBuilder,
    this.padding,
  });

  final ChatRoomListOption queryOption;
  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final EdgeInsetsGeometry? padding;

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
    return FirestoreQueryBuilder(
      query: query,
      builder: (context, snapshot, child) {
        if (snapshot.hasError) {
          dog('chat.room.list_view.dart Something went wrong: ${snapshot.error}');
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        }
        if (snapshot.isFetching && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.docs.isEmpty) {
          return emptyBuilder?.call(context) ??
              const Center(
                // TODO t?
                child: Text("No chat yet."),
              );
        }
        final docs = snapshot.docs;
        final chatRooms =
            docs.map((doc) => ChatRoom.fromSnapshot(doc)).toList();
        return ListView.builder(
          padding: padding,
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            if (index + 1 == snapshot.docs.length && snapshot.hasMore) {
              snapshot.fetchMore();
            }
            final room = chatRooms[index];
            if (itemBuilder != null) {
              return itemBuilder!(context, room, index);
            }
            return ChatRoomListTile(
              room: room,
            );
          },
        );
      },
    );
  }
}
