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
  receivedInvites,
  rejectedInvites;

  Query get query {
    Query q = ChatService.instance.roomCol;
    if (this == ChatRoomQuery.allMine) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.order}',
        descending: true,
      );
    } else if (this == ChatRoomQuery.allMineByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.timeOrder}',
        descending: true,
      );
    } else if (this == ChatRoomQuery.open) {
      q = q
          .where(ChatRoom.field.open, isEqualTo: true)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    } else if (this == ChatRoomQuery.single) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleOrder}',
        descending: true,
      );
    } else if (this == ChatRoomQuery.singleByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleTimeOrder}',
        descending: true,
      );
    } else if (this == ChatRoomQuery.group) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupOrder}',
        descending: true,
      );
    } else if (this == ChatRoomQuery.groupByTime) {
      q = q.orderBy(
        '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupTimeOrder}',
        descending: true,
      );
    } else if (this == ChatRoomQuery.receivedInvites) {
      q = q
          .where(ChatRoom.field.invitedUsers, arrayContains: myUid)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    } else if (this == ChatRoomQuery.rejectedInvites) {
      q = q
          .where(ChatRoom.field.rejectedUsers, arrayContains: myUid)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    }
    return q;
  }
}
