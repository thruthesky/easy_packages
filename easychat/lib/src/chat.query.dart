import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';

enum ChatRoomQuery {
  allMine,
  allMineByTime,
  open,
  single,
  singleByTime,
  group,
  groupByTime,
  ;

  Query get query {
    Query q = ChatService.instance.roomCol;
    if (this == allMine) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.order}',
        descending: true,
      );
    } else if (this == allMineByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.timeOrder}',
        descending: true,
      );
    } else if (this == open) {
      q = q
          .where(ChatRoom.field.open, isEqualTo: true)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    } else if (this == single) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleOrder}',
        descending: true,
      );
    } else if (this == singleByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleTimeOrder}',
        descending: true,
      );
    } else if (this == group) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupOrder}',
        descending: true,
      );
    } else if (this == groupByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupTimeOrder}',
        descending: true,
      );
    }

    return q;
  }

  static Query receivedInvites() {
    return ChatService.instance.roomCol
        .where(ChatRoom.field.invitedUsers, arrayContains: myUid)
        .orderBy(ChatRoom.field.updatedAt, descending: true);
  }

  static Query rejectedInvites() {
    return ChatService.instance.roomCol
        .where(ChatRoom.field.rejectedUsers, arrayContains: myUid)
        .orderBy(ChatRoom.field.updatedAt, descending: true);
  }

  static Query unread() {
    return ChatService.instance.roomCol.where(
      '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.newMessageCounter}',
      isGreaterThan: 0,
    );
  }
}
