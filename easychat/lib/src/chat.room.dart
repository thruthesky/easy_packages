import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

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
    hasPassword: 'hasPassword',
    open: 'open',
    single: 'single',
    group: 'group',
    lastMessageText: 'lastMessageText',
    lastMessageAt: 'lastMessageAt',
    lastMessageUid: 'lastMessageUid',
    lastMessageUrl: 'lastMessageUrl',
    lastMessageId: 'lastMessageId',
    lastMessageDeleted: 'lastMessageDeleted',
    verifiedUserOnly: 'verifiedUserOnly',
    urlForVerifiedUserOnly: 'urlForVerifiedUserOnly',
    uploadForVerifiedUserOnly: 'uploadForVerifiedUserOnly',
    gender: 'gender',
    domain: 'domain',
  );

  /// [id] is the chat room id.
  String id;

  static CollectionReference col = ChatService.instance.roomCol;

  /// [messageRef] is the message reference of the chat room.
  DatabaseReference get messageRef =>
      FirebaseDatabase.instance.ref("/chat-messages/$id");

  /// [ref] is the docuement reference of the chat room.
  DocumentReference get ref => col.doc(id);

  /// [name] is the chat room name. If it does not exist, it is empty.
  String name;

  /// [description] is the chat room description. If it does not exist, it is empty.
  String description;

  /// The icon url of the chat room. optinal.
  String? iconUrl;

  /// [users] is the uid list of users who are join the room
  Map<String, ChatRoomUser> users;

  List<String> get userUids => users.keys.toList();

  bool get joined => userUids.contains(myUid);

  List<String> invitedUsers;
  List<String> rejectedUsers;
  List<String> blockedUsers;
  List<String> masterUsers;

  DateTime createdAt;
  DateTime updatedAt;

  /// [hasPassword] is true if the chat room has password
  ///
  /// Note, this is not implemented yet.
  bool hasPassword;

  /// [open] is true if the chat room is open chat
  bool open;

  /// [single] is true if the chat room is single chat or 1:1.
  bool single;

  /// [group] is true if the chat room is group chat.
  bool group;

  String? lastMessageId;
  String? lastMessageText;
  DateTime? lastMessageAt;
  String? lastMessageUid;
  String? lastMessageUrl;
  bool? lastMessageDeleted;

  /// [verifiedUserOnly] is true if only the verified users can enter the chat room.
  ///
  /// Note that, [verifiedUserOnly] is not supported at this time.
  bool verifiedUserOnly;

  /// [urlForVerifiedUserOnly] is true if only the verified users can sent the
  /// url (or include any url in the text).
  ///
  /// Note that, [urlForVerifiedUserOnly] is not supported at this time.
  bool urlForVerifiedUserOnly;

  /// [uploadForVerifiedUserOnly] is true if only the verified users can sent the
  /// photo.
  ///
  /// Note that, [uploadForVerifiedUserOnly] is not supported at this time.
  bool uploadForVerifiedUserOnly;

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
  /// This is used to filter the chat room by the app. For instance, many apps
  /// can share the same Firebase and Firestore. And each app can have its own
  /// chat rooms. So, the domain is used to filter the chat rooms by the app.
  /// In the other way, that some apps want to share the same chat rooms and
  /// some other apps don't want to share the chat rooms. In this case, the
  /// domain can be used to filter the chat rooms by the app.
  String domain;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.open = false,
    this.single = false,
    this.group = true,
    this.hasPassword = false,
    required this.users,
    required this.masterUsers,
    this.invitedUsers = const [],
    this.blockedUsers = const [],
    this.rejectedUsers = const [],
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageId,
    this.lastMessageText,
    this.lastMessageAt,
    this.lastMessageUid,
    this.lastMessageUrl,
    this.lastMessageDeleted,
    this.verifiedUserOnly = false,
    this.urlForVerifiedUserOnly = false,
    this.uploadForVerifiedUserOnly = false,
    required this.gender,
    required this.domain,
  });

  factory ChatRoom.fromSnapshot(DocumentSnapshot doc) {
    return ChatRoom.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json, String id) {
    final usersMap = Map<String, dynamic>.from((json['users'] ?? {}) as Map);
    final users = Map<String, ChatRoomUser>.fromEntries(usersMap.entries.map(
        (entry) =>
            MapEntry(entry.key, ChatRoomUser.fromJson(json: entry.value))));
    return ChatRoom(
      id: id,
      name: json[field.name] ?? '',
      description: json[field.description] ?? '',
      iconUrl: json[field.iconUrl],
      open: json[field.open],
      single: json[field.single],
      group: json[field.group],
      hasPassword: json[field.hasPassword],
      users: users,
      masterUsers: List<String>.from(json[field.masterUsers]),
      invitedUsers: List<String>.from(json[field.invitedUsers] ?? []),
      blockedUsers: List<String>.from(json[field.blockedUsers] ?? []),
      rejectedUsers: List<String>.from(json[field.rejectedUsers] ?? []),
      createdAt: json[field.createdAt] is Timestamp
          ? (json[field.createdAt] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json[field.updatedAt] is Timestamp
          ? (json[field.updatedAt] as Timestamp).toDate()
          : DateTime.now(),
      lastMessageId: json[field.lastMessageId],
      lastMessageText: json[field.lastMessageText],
      lastMessageAt: json[field.lastMessageAt] is Timestamp
          ? (json[field.lastMessageAt] as Timestamp).toDate()
          : DateTime.now(),
      lastMessageUid: json[field.lastMessageUid],
      lastMessageUrl: json[field.lastMessageUrl],
      lastMessageDeleted: json[field.lastMessageDeleted],
      verifiedUserOnly: json[field.verifiedUserOnly],
      urlForVerifiedUserOnly: json[field.urlForVerifiedUserOnly],
      uploadForVerifiedUserOnly: json[field.uploadForVerifiedUserOnly],
      gender: json[field.gender],
      domain: json[field.domain],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      field.name: name,
      field.description: description,
      field.iconUrl: iconUrl,
      field.open: open,
      field.single: single,
      field.group: group,
      field.hasPassword: hasPassword,
      field.users: Map<String, dynamic>.fromEntries(
        users.map((uid, user) => MapEntry(uid, user.toJson())).entries,
      ),
      field.masterUsers: masterUsers,
      field.invitedUsers: invitedUsers,
      field.blockedUsers: blockedUsers,
      field.rejectedUsers: rejectedUsers,
      field.createdAt: createdAt,
      field.updatedAt: updatedAt,
      field.lastMessageId: lastMessageId,
      field.lastMessageText: lastMessageText,
      field.lastMessageAt: lastMessageAt,
      field.lastMessageUid: lastMessageUid,
      field.lastMessageUrl: lastMessageUrl,
      field.lastMessageDeleted: lastMessageDeleted,
      field.verifiedUserOnly: verifiedUserOnly,
      field.urlForVerifiedUserOnly: urlForVerifiedUserOnly,
      field.uploadForVerifiedUserOnly: uploadForVerifiedUserOnly,
      field.gender: gender,
      field.domain: domain,
    };
  }

  copyFromSnapshot(DocumentSnapshot doc) {
    copyFrom(ChatRoom.fromSnapshot(doc));
  }

  copyFrom(ChatRoom room) {
    // copy all the fields from the room
    id = room.id;
    name = room.name;
    description = room.description;
    iconUrl = room.iconUrl;
    open = room.open;
    single = room.single;
    group = room.group;
    hasPassword = room.hasPassword;
    users = room.users;
    masterUsers = room.masterUsers;
    invitedUsers = room.invitedUsers;
    blockedUsers = room.blockedUsers;
    rejectedUsers = room.rejectedUsers;
    createdAt = room.createdAt;
    updatedAt = room.updatedAt;
    lastMessageText = room.lastMessageText;
    lastMessageAt = room.lastMessageAt;
    lastMessageUid = room.lastMessageUid;
    lastMessageUrl = room.lastMessageUrl;
    verifiedUserOnly = room.verifiedUserOnly;
    urlForVerifiedUserOnly = room.urlForVerifiedUserOnly;
    uploadForVerifiedUserOnly = room.uploadForVerifiedUserOnly;
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
  /// Returns the document reference of the chat room.
  ///
  /// If [id] is null, this will make new room id (preferred for
  /// group chat)
  static Future<DocumentReference> create({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    bool open = false,
    // Group == false means the chat room is single chat
    bool group = true,
    bool single = false,
    // String? password, (NOT IMPLEMENTED YET)
    List<String>? invitedUsers,
    List<String>? users,
    List<String>? masterUsers,
    bool verifiedUserOnly = false,
    bool urlForVerifiedUserOnly = false,
    bool uploadForVerifiedUserOnly = false,
    String gender = '',
    String domain = '',
  }) async {
    if (single == true && (group == true || open == true)) {
      throw 'chat-room-create/single-cannot-be-group-or-open Single chat room cannot be group or open';
    }
    if (single == false && group == false) {
      throw 'chat-room-create/single-or-group Single or group chat room must be selected';
    }

    Map<String, dynamic> usersMap = {};
    if (users != null && users.isNotEmpty) {
      usersMap = Map.fromEntries(
        users.map(
          (uid) => MapEntry(uid, {
            if (single) ...{
              ChatRoomUser.field.singleOrder: FieldValue.serverTimestamp(),
              ChatRoomUser.field.singleTimeOrder: FieldValue.serverTimestamp(),
            },
            if (group) ...{
              ChatRoomUser.field.groupOrder: FieldValue.serverTimestamp(),
              ChatRoomUser.field.groupTimeOrder: FieldValue.serverTimestamp(),
            },
            ChatRoomUser.field.order: FieldValue.serverTimestamp(),
            ChatRoomUser.field.timeOrder: FieldValue.serverTimestamp(),
            ChatRoomUser.field.newMessageCounter: 1,
          }),
        ),
      );
    }

    final newRoom = {
      if (name != null) field.name: name,
      if (description != null) field.description: description,
      if (iconUrl != null) field.iconUrl: iconUrl,
      field.open: open,
      field.single: single,
      field.group: group,
      field.hasPassword: false,
      if (invitedUsers != null) field.invitedUsers: invitedUsers,
      field.users: usersMap,
      field.masterUsers: [myUid],
      field.verifiedUserOnly: verifiedUserOnly,
      field.urlForVerifiedUserOnly: urlForVerifiedUserOnly,
      field.uploadForVerifiedUserOnly: uploadForVerifiedUserOnly,
      field.gender: gender,
      field.domain: domain,
      field.createdAt: FieldValue.serverTimestamp(),
      field.updatedAt: FieldValue.serverTimestamp(),
    };

    DocumentReference ref;
    if (id == null) {
      ref = await col.add(newRoom);
    } else {
      ref = col.doc(id);
      await ref.set(newRoom);
    }
    return ref;
  }

  /// [createSingle] creates a new single chat room.
  static Future<DocumentReference> createSingle(String otherUid) {
    return create(
      group: false,
      single: true,
      id: singleChatRoomId(otherUid),
      invitedUsers: otherUid == myUid ? null : [otherUid],
      users: [myUid!],
      masterUsers: [myUid!],
    );
  }

  /// [get] gets the chat room by id.
  static Future<ChatRoom?> get(String id) async {
    final snapshotDoc = await ChatRoom.col.doc(id).get();
    if (snapshotDoc.exists == false) return null;
    return ChatRoom.fromSnapshot(snapshotDoc);
  }

  /// [update] updates the chat room.
  Future<void> update({
    String? name,
    String? description,
    String? iconUrl,
    bool? open,
    bool? single,
    bool? group,
    String? lastMessageText,
    Object? lastMessageAt,
    String? lastMessageUid,
    String? lastMessageUrl,
    bool? lastMessageDeleted,
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
      if (lastMessageText != null) field.lastMessageText: lastMessageText,
      if (lastMessageAt != null) field.lastMessageAt: lastMessageAt,
      if (lastMessageUid != null) field.lastMessageUid: lastMessageUid,
      if (lastMessageUrl != null) field.lastMessageUrl: lastMessageUrl,
      if (lastMessageDeleted != null)
        field.lastMessageDeleted: lastMessageDeleted,
      field.updatedAt: FieldValue.serverTimestamp(),
    };

    await ref.update(updateData);
  }

  Future<void> inviteUser(String uid) async {
    await ref.update({
      field.invitedUsers: FieldValue.arrayUnion([uid]),
      field.updatedAt: FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptInvitation() async {
    final timestampAtLastMessage = lastMessageAt != null
        ? Timestamp.fromDate(lastMessageAt!)
        : FieldValue.serverTimestamp();
    await ref.set(
      {
        field.invitedUsers: FieldValue.arrayRemove([myUid!]),
        field.users: {
          myUid!: {
            if (single) ...{
              ChatRoomUser.field.singleOrder: FieldValue.serverTimestamp(),
              ChatRoomUser.field.singleTimeOrder: timestampAtLastMessage,
            },
            if (group) ...{
              ChatRoomUser.field.groupOrder: FieldValue.serverTimestamp(),
              ChatRoomUser.field.groupTimeOrder: timestampAtLastMessage,
            },
            ChatRoomUser.field.order: FieldValue.serverTimestamp(),
            ChatRoomUser.field.timeOrder: timestampAtLastMessage,
            // need to add new message so that the order will be correct after reading,
            ChatRoomUser.field.newMessageCounter: FieldValue.increment(1),
          },
        },
        // In case, the user rejected the invitation
        // but actually wants to accept it, then we should
        // also remove the uid from rejeceted users.
        field.rejectedUsers: FieldValue.arrayRemove([myUid!]),
        field.updatedAt: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  /// Alias for [acceptInvitation]. Since they have
  /// related logic.
  Future<void> join() => acceptInvitation();

  Future<void> rejectInvitation() async {
    await ref.update({
      field.invitedUsers: FieldValue.arrayRemove([myUid!]),
      field.rejectedUsers: FieldValue.arrayUnion([myUid!]),
    });
  }

  Future<void> leave() async {
    // TODO masters should not leave right away
    await ref.set(
      {
        field.users: {
          myUid!: FieldValue.delete(),
        },
      },
      SetOptions(merge: true),
    );
  }

  /// This only subtracts about 50 years in time. Using subtraction
  /// will help to preserve order after reading the message.
  /// There is a minimum limit for Timestamp for Firestore, that is why,
  /// we can only do a subtraction of about 50 years.
  Timestamp _negatedOrder(DateTime order) =>
      Timestamp.fromDate(order.subtract(const Duration(days: 19000)));

  /// [updateNewMessagesMeta] is used to update all unread data for all
  /// users inside the chat room.
  Future<void> updateNewMessagesMeta({
    String? lastMessageId,
    String? lastMessageText,
    String? lastMessageUrl,
  }) async {
    final serverTimestamp = FieldValue.serverTimestamp();
    final Map<String, Map<String, Object>> updateUserData = users.map(
      (uid, value) {
        if (uid == myUid!) {
          final readOrder = _negatedOrder(DateTime.now());
          return MapEntry(
            uid,
            {
              if (single) ...{
                ChatRoomUser.field.singleOrder: readOrder,
                ChatRoomUser.field.singleTimeOrder: serverTimestamp,
              },
              if (group) ...{
                ChatRoomUser.field.groupOrder: readOrder,
                ChatRoomUser.field.groupTimeOrder: serverTimestamp,
              },
              ChatRoomUser.field.order: readOrder,
              ChatRoomUser.field.timeOrder: serverTimestamp,
              ChatRoomUser.field.newMessageCounter: 0,
            },
          );
        }
        return MapEntry(
          uid,
          {
            if (single) ...{
              ChatRoomUser.field.singleOrder: serverTimestamp,
              ChatRoomUser.field.singleTimeOrder: serverTimestamp,
            },
            if (group) ...{
              ChatRoomUser.field.groupOrder: serverTimestamp,
              ChatRoomUser.field.groupTimeOrder: serverTimestamp,
            },
            ChatRoomUser.field.order: serverTimestamp,
            ChatRoomUser.field.timeOrder: serverTimestamp,
            ChatRoomUser.field.newMessageCounter: FieldValue.increment(1),
          },
        );
      },
    );
    await ref.set({
      field.lastMessageId: lastMessageId,
      if (lastMessageText != null) field.lastMessageText: lastMessageText,
      field.lastMessageAt: FieldValue.serverTimestamp(),
      field.lastMessageUid: myUid!,
      if (lastMessageUrl != null) field.lastMessageUrl: lastMessageUrl,
      field.lastMessageDeleted: false,
      field.users: {
        ...updateUserData,
      },
    }, SetOptions(merge: true));
  }

  /// [updateMyReadMeta] is used to set as read by the current user.
  /// It means, turning newMessageCounter into zero
  /// and updating the order.
  ///
  /// The update will proceed only if newMessageCounter is not 0.
  /// The Chat Room must be updated or else, it may not proceed
  /// when old room data is 0, since newMessageCounter maybe inaccurate.
  Future<void> updateMyReadMeta() async {
    if (!userUids.contains(myUid!)) return;
    if (users[myUid!]!.newMessageCounter == 0) return;
    final myReadOrder = users[myUid!]!.timeOrder;
    final updatedOrder = _negatedOrder(myReadOrder!);
    await ref.set({
      field.users: {
        my.uid: {
          if (single) ChatRoomUser.field.singleOrder: updatedOrder,
          if (group) ChatRoomUser.field.groupOrder: updatedOrder,
          ChatRoomUser.field.order: updatedOrder,
          ChatRoomUser.field.newMessageCounter: 0,
        }
      }
    }, SetOptions(merge: true));
  }

  Future<void> mayDeleteLastMessage(String deletedMessageId) async {
    dog("lastMessageId: $lastMessageId");
    dog("deletedMessageId: $deletedMessageId");
    if (lastMessageId == deletedMessageId) {
      await ref.set({
        field.lastMessageText: FieldValue.delete(),
        field.lastMessageUrl: FieldValue.delete(),
        field.lastMessageDeleted: true,
      }, SetOptions(merge: true));
    }
  }

  Future<void> mayUpdateLastMessage({
    required String messageId,
    String? updatedMessageText,
    String? updatedMessageUrl,
  }) async {
    dog("lastMessageId: $lastMessageId");
    dog("updatedMessageId: $messageId");
    if (lastMessageId == messageId) {
      await ref.set({
        field.lastMessageText: updatedMessageText,
        field.lastMessageUrl: updatedMessageUrl,
      }, SetOptions(merge: true));
    }
  }

  /// To reply, it must be set here.
  ///
  /// Reason: Input box is the widget that sends the message
  ///         with or without reply to. Since popup menu is
  ///         separate widget and is the ui of the reply button,
  ///         it needs to store it somewhere accessible
  ///         by input box. So that the input box can know if we
  ///         are replying.
  ValueNotifier<ChatMessage?>? replyValueNotifier;

  void initReply() {
    if (replyValueNotifier != null) disposeReply();
    replyValueNotifier = ValueNotifier<ChatMessage?>(null);
  }

  void disposeReply() {
    if (replyValueNotifier != null) {
      replyValueNotifier!.dispose();
      replyValueNotifier = null;
      return;
    }
  }

  void replyTo(ChatMessage chatMessage) {
    if (replyValueNotifier == null) {
      throw ChatException('reply-value-notifier-not-initialized',
          'replyValueNotifier must be initialized');
    }
    replyValueNotifier!.value = chatMessage;
  }
}
