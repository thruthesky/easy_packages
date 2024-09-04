import 'dart:async';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easyuser/easyuser.dart';

class ChatRoom {
  /// Field names used for the Firestore document
  static const field = (
    name: 'name',
    description: 'description',
    iconUrl: 'iconUrl',
    users: 'users',
    invitedUsers: 'invitedUsers',
    rejectedUsers: 'rejectedUsers',
    blockedUsers: 'blockedUsers',
    masterUsers: 'masterUsers',
    createdAt: 'createdAt',
    updatedAt: 'updatedAt',
    open: 'open',
    single: 'single',
    group: 'group',
    lastMessageAt: 'lastMessageAt',
    verifiedUserOnly: 'verifiedUserOnly',
    urlForVerifiedUserOnly: 'urlForVerifiedUserOnly',
    uploadForVerifiedUserOnly: 'uploadForVerifiedUserOnly',
    allMembersCanInvite: 'allMembersCanInvite',
    gender: 'gender',
    domain: 'domain',
  );

  /// [id] is the chat room id. This is the key of the chat room data.
  String id;

  /// [ref] is the data reference of the chat room.
  DatabaseReference get ref => ChatService.instance.roomsRef.child(id);

  /// [name] is the chat room name. If it does not exist, it is empty.
  String name;

  /// [description] is the chat room description. If it does not exist, it is empty.
  String description;

  /// The icon url of the chat room. optinal.
  String? iconUrl;

  /// [users] is the uid list of users who are join the room
  // Map<String, ChatRoomUser> users;
  Map<String, bool> users;

  // List<String> get userUids => users.keys.toList();
  // TODO clean up and depricate
  List<String> get userUids => users.keys.toList();

  bool get joined => userUids.contains(myUid);

  List<String> blockedUsers;
  List<String> masterUsers;

  DateTime createdAt;
  DateTime updatedAt;

  /// [open] is true if the chat room is open chat
  bool open;

  /// [single] is true if the chat room is single chat or 1:1.
  bool single;

  /// [group] is true if the chat room is group chat.
  bool group;

  /// [lastMessageAt] is the time when last message was sent to chat room.
  int? lastMessageAt;

  /// [gender] to filter the chat room by user's gender.
  /// If it's M, then only male can enter the chat room. And if it's F,
  /// only female can enter the chat room.
  ///
  /// Note that, [gender] is not supported at this time.
  String gender;

  /// [noOfUsers] is the number of users in the chat room.
  int get noOfUsers => users.length;

  /// [domain] is the domain of the chat room. It can be the name of the app.
  ///
  String domain;

  bool allMembersCanInvite = false;

  /// True if the user has seen the last message. Meaning, there is no more new messages in the chat room.
  // bool get iSeen => users[myUid!].newMessageCounter == 0;
  // TODO CLEAN UP
  bool get iSeen => false;

  /// Uids for single chat is combination of both users' uids separated by "---"
  /// Returns list of uids based on the room id.
  List<String> get uidsFromRoomId => id.contains("---") ? id.split("---") : [];

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.open,
    required this.single,
    required this.group,
    required this.users,
    required this.masterUsers,
    this.blockedUsers = const [],
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageAt,
    this.allMembersCanInvite = false,
    required this.gender,
    required this.domain,
  });

  factory ChatRoom.fromSnapshot(DataSnapshot data) {
    return ChatRoom.fromJson(
        (Map<String, dynamic>.from(data.value as Map)), data.key!);
  }

  static Map<String, bool> convertMapToStringBool(
      Map<Object?, Object?>? original) {
    if (original == null) return {};
    Map<String, bool> newMap = {};

    original.forEach((key, value) {
      if (key is String && value is bool) {
        newMap[key] = value;
      }
    });

    return newMap;
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json, String id) {
    dog("Users Typing: ${json['users'].runtimeType}");
    // TODO cleanup
    // final usersMap = Map<String, dynamic>.from((json['users'] ?? {}) as Map);
    // final users = List<String>.from(json['users'] as List<Object?>);
    // final users = Map<String, ChatRoomUser>.fromEntries(usersEntries.map(
    //     (entry) =>
    //         MapEntry(entry.key, ChatRoomUser.fromJson(json: entry.value))));
    return ChatRoom(
      id: id,
      name: json[field.name] ?? '',
      description: json[field.description] ?? '',
      iconUrl: json[field.iconUrl],
      open: json[field.open],
      single: json[field.single],
      group: json[field.group],
      users: json[field.users] is Map
          ? Map<String, bool>.from(json[field.users])
          : {},
      masterUsers: List<String>.from(json[field.masterUsers]),
      blockedUsers: List<String>.from(json[field.blockedUsers] ?? []),
      createdAt: json[field.createdAt] is num
          ? DateTime.fromMillisecondsSinceEpoch(json[field.createdAt])
          : DateTime.now(),
      updatedAt: json[field.updatedAt] is num
          ? DateTime.fromMillisecondsSinceEpoch(json[field.updatedAt])
          : DateTime.now(),
      lastMessageAt:
          json[field.lastMessageAt] ?? DateTime.now().millisecondsSinceEpoch,
      allMembersCanInvite: json[field.allMembersCanInvite] ?? false,
      gender: json[field.gender],
      domain: json[field.domain],
    );
  }

  @Deprecated('Do not use it if it is only for the toString() method.')
  Map<String, dynamic> toJson() {
    return {
      field.name: name,
      field.description: description,
      field.iconUrl: iconUrl,
      field.open: open,
      field.single: single,
      field.group: group,
      // TODO, clean up, will be deprecated anyway
      // field.users: Map<String, dynamic>.fromEntries(
      //   users.map((uid, user) => MapEntry(uid, user.toJson())).entries,
      // ),
      field.masterUsers: masterUsers,
      field.blockedUsers: blockedUsers,
      field.createdAt: createdAt,
      field.updatedAt: updatedAt,
      field.lastMessageAt: lastMessageAt,
      field.allMembersCanInvite: allMembersCanInvite,
      field.gender: gender,
      field.domain: domain,
    };
  }

  @Deprecated(
      'DO NOT USE THIS: Why do we need this? Use it if it saved time and money')
  copyFromSnapshot(DataSnapshot doc) {
    copyFrom(ChatRoom.fromSnapshot(doc));
  }

  @Deprecated(
      'DO NOT USE THIS: Why do we need this? Use it if it saved time and money')
  copyFrom(ChatRoom room) {
    // copy all the fields from the room
    id = room.id;
    name = room.name;
    description = room.description;
    iconUrl = room.iconUrl;
    open = room.open;
    single = room.single;
    group = room.group;
    users = room.users;
    masterUsers = room.masterUsers;
    blockedUsers = room.blockedUsers;
    createdAt = room.createdAt;
    updatedAt = room.updatedAt;
    lastMessageAt = room.lastMessageAt;
    allMembersCanInvite = room.allMembersCanInvite;
    gender = room.gender;
    domain = room.domain;
  }

  /// toString
  @override
  String toString() {
    return 'ChatRoom(${toJson()})';
  }

  /// [create] creates a new chat room.
  ///
  ///
  /// Returns the database reference of the chat room.
  ///
  /// If [id] is null, this will make new room id (preferred for group chat)
  static Future<DatabaseReference> create({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    bool open = false,
    // Group == false means the chat room is single chat
    bool group = true,
    bool single = false,
    // String? password, (NOT IMPLEMENTED YET)
    Map<String, bool>? users,
    List<String>? masterUsers,
    bool verifiedUserOnly = false,
    bool urlForVerifiedUserOnly = false,
    bool uploadForVerifiedUserOnly = false,
    bool allMembersCanInvite = false,
    String gender = '',
    String domain = '',
  }) async {
    if (single == true && (group == true || open == true)) {
      throw 'chat-room-create/single-cannot-be-group-or-open Single chat room cannot be group or open';
    }
    if (single == false && group == false) {
      throw 'chat-room-create/single-or-group Single or group chat room must be selected';
    }

    // Map<String, dynamic> usersMap = {};
    // if (users != null && users.isNotEmpty) {
    //   usersMap = Map.fromEntries(
    //     users.map(
    //       (uid) => MapEntry(uid, {
    //         if (single) ...{
    //           ChatRoomUser.field.singleOrder: FieldValue.serverTimestamp(),
    //           ChatRoomUser.field.singleTimeOrder: FieldValue.serverTimestamp(),
    //         },
    //         if (group) ...{
    //           ChatRoomUser.field.groupOrder: FieldValue.serverTimestamp(),
    //           ChatRoomUser.field.groupTimeOrder: FieldValue.serverTimestamp(),
    //         },
    //         ChatRoomUser.field.order: FieldValue.serverTimestamp(),
    //         ChatRoomUser.field.timeOrder: FieldValue.serverTimestamp(),
    //         ChatRoomUser.field.newMessageCounter: 1,
    //       }),
    //     ),
    //   );
    // }

    final newRoom = {
      if (name != null) field.name: name,
      if (description != null) field.description: description,
      if (iconUrl != null) field.iconUrl: iconUrl,
      field.open: open,
      field.single: single,
      field.group: group,
      // if (invitedUsers != null) field.invitedUsers: invitedUsers,
      field.users: users,
      field.masterUsers: [myUid],
      field.verifiedUserOnly: verifiedUserOnly,
      field.urlForVerifiedUserOnly: urlForVerifiedUserOnly,
      field.uploadForVerifiedUserOnly: uploadForVerifiedUserOnly,
      field.allMembersCanInvite: allMembersCanInvite,
      field.gender: gender,
      field.domain: domain,
      field.createdAt: ServerValue.timestamp,
      field.updatedAt: ServerValue.timestamp,
    };

    DatabaseReference newChatRoomRef;
    if (id == null) {
      newChatRoomRef = ChatService.instance.roomsRef.push();
    } else {
      newChatRoomRef = ChatService.instance.roomsRef.child(id);
    }

    final Map<String, Object?> updates = {};
    updates[newChatRoomRef.path] = newRoom;
    updates[ChatService.instance.joinRef(newChatRoomRef.key!).path] = {
      if (single) 'singleChatOrder': ServerValue.timestamp,
      if (group) 'groupChatOrder': ServerValue.timestamp,
      if (open) 'openChatOrder': ServerValue.timestamp,
      'joinedAt': ServerValue.timestamp,
    };
    await FirebaseDatabase.instance.ref().update(updates);

    //

    return newChatRoomRef;
  }

  /// [createSingle] creates a new single chat room.
  static Future<DatabaseReference> createSingle(
    String otherUid, {
    String domain = '',
  }) async {
    return await create(
      group: false,
      open: false,
      single: true,
      id: singleChatRoomId(otherUid),
      users: {myUid!: false},
      masterUsers: [myUid!],
      domain: domain,
    );
  }

  /// [get] gets the chat room by id.
  static Future<ChatRoom?> get(String id) async {
    final snapshot = await ChatService.instance.roomRef(id).get();
    if (snapshot.exists == false) return null;
    return ChatRoom.fromSnapshot(snapshot);
  }

  /// [update] updates the chat room.
  Future<void> update({
    String? name,
    String? description,
    String? iconUrl,
    bool? open,
    bool? single,
    bool? group,
    // bool? verifiedUserOnly,
    // bool? urlForVerifiedUserOnly,
    // bool? uploadForVerifiedUserOnly,
    bool? allMembersCanInvite,
    // String? gender,
    // String? domain,
    // Object? lastMessageAt,
  }) async {
    if (single == true && (group == true || open == true)) {
      throw 'chat-room-update/single-cannot-be-group-or-open Single chat room cannot be group or open';
    }
    if (single == false && group == false) {
      throw 'chat-room-update/single-or-group Single or group chat room must be selected';
    }
    final updateData = {
      if (name != null) field.name: name,
      if (description != null) field.description: description,
      if (iconUrl != null) field.iconUrl: iconUrl,
      if (open != null) field.open: open,
      if (single != null) field.single: single,
      if (group != null) field.group: group,
      if (allMembersCanInvite != null)
        field.allMembersCanInvite: allMembersCanInvite,
      field.updatedAt: ServerValue.timestamp,
    };

    await ref.update(updateData);
  }

  /// Invite a user
  ///
  /// Note, that updating [updatedAt] is important to keep the order of the
  /// chat room. It is especially useful to count the number of invitations.
  ///
  ///
  @Deprecated(
      'A dart model should have the data modeling and default crud including data modeling logic. This logic should not be here.')
  Future<void> inviteUser(String uid) async {
    // await ref.update({
    //   field.invitedUsers: FieldValue.arrayUnion([uid]),
    //   field.updatedAt: FieldValue.serverTimestamp(),
    // });
    // ChatService.instance.increaseInvitationCount(uid);
    // ChatService.instance.onInvite?.call(room: this, uid: uid);

    final Map<String, Object?> invitation = {};
    // TODO prevent typing
    invitation['chat/invited-users/$uid/$id'] = ServerValue.timestamp;

    FirebaseDatabase.instance.ref().update(invitation);
  }

  /// Alias for [join]. Since they have
  /// really simmilar logic.
  Future<void> acceptInvitation() async {
    await join();
  }

  /// Let the current user join in chat room
  ///
  /// If user is invited, invitation count will decrease
  Future<void> join() async {
    if (blockedUsers.contains(myUid)) {
      throw ChatException(
        'chat-join-fail',
        'failed joining. something went wrong. the room may be private or deleted.'
            .t,
      );
    }

    await ChatService.instance.joinsRef.child(myUid!).child(ref.key!).update({
      'singleChatOrder': ServerValue.timestamp,
      'groupChatOrder': ServerValue.timestamp,
      'openChatOrder': ServerValue.timestamp,
      'joinedAt': ServerValue.timestamp,
    });

    // final timestampAtLastMessage = lastMessageAt != null
    //     ? Timestamp.fromDate(lastMessageAt!)
    //     : FieldValue.serverTimestamp();

    // await ref.set(
    //   {
    //     field.invitedUsers: FieldValue.arrayRemove([myUid!]),
    //     field.users: {
    //       myUid!: {
    //         if (single) ...{
    //           ChatRoomUser.field.singleOrder: FieldValue.serverTimestamp(),
    //           ChatRoomUser.field.singleTimeOrder: timestampAtLastMessage,
    //         },
    //         if (group) ...{
    //           ChatRoomUser.field.groupOrder: FieldValue.serverTimestamp(),
    //           ChatRoomUser.field.groupTimeOrder: timestampAtLastMessage,
    //         },
    //         ChatRoomUser.field.order: FieldValue.serverTimestamp(),
    //         ChatRoomUser.field.timeOrder: timestampAtLastMessage,
    //         // need to add new message so that the order will be correct after reading,
    //         ChatRoomUser.field.newMessageCounter: FieldValue.increment(1),
    //       },
    //     },
    //     // In case, the user rejected the invitation
    //     // but actually wants to accept it, then we should
    //     // also remove the uid from rejeceted users.
    //     field.rejectedUsers: FieldValue.arrayRemove([myUid!]),
    //     field.updatedAt: FieldValue.serverTimestamp(),
    //   },
    //   SetOptions(merge: true),
    // );
    // if (invitedUsers.contains(myUid)) {
    //   await ChatService.instance.decreaseInvitationCount();
    // }
  }

  /// Reject the invitation
  ///
  /// Chat room model is only for modeling chat room data and managing the
  /// default CRUD action. is this method really part of this model?
  Future<void> rejectInvitation() async {
    throw 'Not implemented yet';
    // await ref.update({
    //   field.invitedUsers: FieldValue.arrayRemove([myUid!]),
    //   field.rejectedUsers: FieldValue.arrayUnion([myUid!]),
    // });
    // ChatService.instance.decreaseInvitationCount();
  }

  /// User leaves from the chat room.
  Future<void> leave() async {
    throw 'Not implemented yet';

    // TODO: check if the user can leave.
    // if (canLeave() == false) {
    //   throw 'chat-room-leave-fail';
    // }

    // trancation on removing the user's uid from muplipe places like chat/join, chat/room
  }

  Future updateUnreadMessageCount() async {
    final Map<String, Object?> updates = Map.fromEntries(
      userUids.where((uid) => uid != myUid).map(
            (uid) => MapEntry(
              'chat/settings/$uid/unread-message-count/$id',
              ServerValue.increment(1),
            ),
          ),
    );
    // await ref.update(updateNewMessagesMeta);
    await FirebaseDatabase.instance.ref().update(updates);
  }

  /// This only subtracts about 50 years in time. Using subtraction
  /// will help to preserve order after reading the message.
  /// There is a minimum limit for Timestamp for Firestore, that is why,
  /// we can only do a subtraction of about 50 years.
  // Timestamp _negatedOrder(DateTime order) =>
  //     Timestamp.fromDate(order.subtract(const Duration(days: 19000)));

  /// [updateNewMessagesMeta] is used to update all unread data for all
  /// users inside the chat room.
  /// TODO: Change the name of the function readable(meaningful).
  @Deprecated('DO NOT USE THIS: The function name and the logic is not clear.')
  Future<void> updateNewMessagesMeta() async {
    // final Map<String, dynamic> updateNewMessagesMeta = {
    //   'chat': {
    //     'settings': {
    //       ...users.map(
    //         (uid) => MapEntry(
    //           uid,
    //           {
    //             'unread-message-count': {
    //               id: ServerValue.increment(1) // Firebase increment operation
    //             }
    //           },
    //         ),
    //       )
    //     }
    //   }
    // };
    final Map<String, Object?> updateNewMessagesMeta = Map.fromEntries(
      userUids.where((uid) => uid != myUid).map(
            (uid) => MapEntry(
              'chat/settings/$uid/unread-message-count/$id',
              ServerValue.increment(1),
            ),
          ),
    );
    // await ref.update(updateNewMessagesMeta);
    await FirebaseDatabase.instance.ref().update(updateNewMessagesMeta);

    // throw 'Not implemented yet';

    // TODO
    //

    // final serverTimestamp = FieldValue.serverTimestamp();
    // final Map<String, Map<String, Object>> updateUserData = users.map(
    //   (uid, value) {
    //     if (uid == myUid!) {
    //       final readOrder = _negatedOrder(DateTime.now());
    //       return MapEntry(
    //         uid,
    //         {
    //           if (single) ...{
    //             ChatRoomUser.field.singleOrder: readOrder,
    //             ChatRoomUser.field.singleTimeOrder: serverTimestamp,
    //           },
    //           if (group) ...{
    //             ChatRoomUser.field.groupOrder: readOrder,
    //             ChatRoomUser.field.groupTimeOrder: serverTimestamp,
    //           },
    //           ChatRoomUser.field.order: readOrder,
    //           ChatRoomUser.field.timeOrder: serverTimestamp,
    //           ChatRoomUser.field.newMessageCounter: 0,
    //         },
    //       );
    //     }
    //     return MapEntry(
    //       uid,
    //       {
    //         if (single) ...{
    //           ChatRoomUser.field.singleOrder: serverTimestamp,
    //           ChatRoomUser.field.singleTimeOrder: serverTimestamp,
    //         },
    //         if (group) ...{
    //           ChatRoomUser.field.groupOrder: serverTimestamp,
    //           ChatRoomUser.field.groupTimeOrder: serverTimestamp,
    //         },
    //         ChatRoomUser.field.order: serverTimestamp,
    //         ChatRoomUser.field.timeOrder: serverTimestamp,
    //         ChatRoomUser.field.newMessageCounter: FieldValue.increment(1),
    //       },
    //     );
    //   },
    // );
    // await ref.set({
    //   field.users: {
    //     ...updateUserData,
    //   },
    //   field.lastMessageAt: serverTimestamp,
    // }, SetOptions(merge: true));
  }

  /// [resetUnreadMessage] is used to set as read by the current user.
  /// It means, turning newMessageCounter into zero
  /// and updating the order.
  ///
  /// The update will proceed only if newMessageCounter is not 0.
  /// The Chat Room must be updated or else, it may not proceed
  /// when old room data is 0, since newMessageCounter maybe inaccurate.
  Future<void> resetUnreadMessage() async {
    ChatService.instance.unreadMessageCountRef(id).set(0);

    // throw 'Not implemented yet';

    // TODO review. It must update the order
    // if (!userUids.contains(myUid!)) return;
    // if (users[myUid!]!.newMessageCounter == 0) return;
    // final myReadOrder = users[myUid!]!.timeOrder;
    // final updatedOrder = _negatedOrder(myReadOrder!);
    // await ref.set({
    //   field.users: {
    //     my.uid: {
    //       if (single) ChatRoomUser.field.singleOrder: updatedOrder,
    //       if (group) ChatRoomUser.field.groupOrder: updatedOrder,
    //       ChatRoomUser.field.order: updatedOrder,
    //       ChatRoomUser.field.newMessageCounter: 0,
    //     }
    //   }
    // }, SetOptions(merge: true));
  }

  /// [block] blocks the user from the chat room.
  /// It can be done by the master.
  block(String uid) async {
    throw 'Not implemented yet';

    // 1. check if the user is the master
    // 2. check if the user can be blocked
    // 3. block the user
  }

  /// [unblock] unblocks the user from the chat room.
  /// It can be done by the master
  unblock(String uid) async {
    // 1. check if the user is the master
    // 2. check if the user can be unblocked
    // 3. unblock the user
  }
}
