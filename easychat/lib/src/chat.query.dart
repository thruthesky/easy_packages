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
  groupByTime;

  Query get query {
    Query q = ChatService.instance.roomCol;
    if (this == allMine) {
      q = q
          .where(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.order}',
            isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0),
          )
          .orderBy(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.order}',
            descending: true,
          );
    } else if (this == allMineByTime) {
      q = q
          .where(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.timeOrder}',
            isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0),
          )
          .orderBy(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.timeOrder}',
            descending: true,
          );
    } else if (this == open) {
      q = q
          .where(ChatRoom.field.open, isEqualTo: true)
          .orderBy(ChatRoom.field.updatedAt, descending: true);
    } else if (this == single) {
      q = q
          .where(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleOrder}',
            isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0),
          )
          .orderBy(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleOrder}',
            descending: true,
          );
    } else if (this == singleByTime) {
      q = q
          .where(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleTimeOrder}',
            isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0),
          )
          .orderBy(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.singleTimeOrder}',
            descending: true,
          );
    } else if (this == group) {
      q = q
          .where(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupOrder}',
            isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0),
          )
          .orderBy(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupOrder}',
            descending: true,
          );
    } else if (this == groupByTime) {
      q = q
          .where(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupTimeOrder}',
            isGreaterThan: Timestamp.fromMicrosecondsSinceEpoch(0),
          )
          .orderBy(
            '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.groupTimeOrder}',
            descending: true,
          );
    }
    return q;
  }

  /// Returns a query for chat rooms where the current user is invited.
  ///
  /// Note, that this query is ordered by [ChatRoom.field.updatedAt] in
  /// descending order. This is important to count the number of invitations.
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

  /// Returns a query for unread chat rooms.
  static Query unread() {
    return ChatService.instance.roomCol.where(
      '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.newMessageCounter}',
      isGreaterThan: 0,
    );
  }
}
