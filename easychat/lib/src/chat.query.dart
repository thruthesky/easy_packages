import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';

class ChatQuery {
  static Query q = ChatService.instance.roomCol;
  static Query get inviteList => q
      .where(ChatRoom.field.invitedUsers, arrayContains: myUid)
      .orderBy(ChatRoom.field.updatedAt, descending: true);
}
