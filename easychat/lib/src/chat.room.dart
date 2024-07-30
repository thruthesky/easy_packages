import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:easychat/src/chat.room.user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easychat/src/chat.service.dart';
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
    hasPassword: 'hasPassword',
    open: 'open',
    single: 'single',
    group: 'group',
    lastMessageText: 'lastMessageText',
    lastMessageAt: 'lastMessageAt',
    lastMessageUid: 'lastMessageUid',
    lastMessageUrl: 'lastMessageUrl',
    verifiedUserOnly: 'verifiedUserOnly',
    urlForVerifiedUserOnly: 'urlForVerifiedUserOnly',
    uploadForVerifiedUserOnly: 'uploadForVerifiedUserOnly',
    gender: 'gender',
    domain: 'domain',
  );

  /// [id] is the chat room id.
  final String id;

  static CollectionReference col = ChatService.instance.roomCol;

  /// [messageRef] is the message reference of the chat room.
  DatabaseReference get messageRef =>
      FirebaseDatabase.instance.ref("/chat-messages/$id");

  /// [ref] is the docuement reference of the chat room.
  DocumentReference get ref => col.doc(id);

  /// [name] is the chat room name. If it does not exist, it is empty.
  final String name;

  /// [description] is the chat room description. If it does not exist, it is empty.
  final String description;

  /// The icon url of the chat room. optinal.
  final String? iconUrl;

  /// [users] is the uid list of users who are join the room
  final Map<String, ChatRoomUser> users;

  List<String> get userUids => users.keys.toList();

  final List<String> invitedUsers;
  final List<String> rejectedUsers;
  final List<String> blockedUsers;
  final List<String> masterUsers;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// [hasPassword] is true if the chat room has password
  ///
  /// Note, this is not implemented yet.
  final bool hasPassword;

  /// [open] is true if the chat room is open chat
  final bool open;

  /// [single] is true if the chat room is single chat or 1:1.
  final bool single;

  /// [group] is true if the chat room is group chat.
  final bool group;

  final String? lastMessageText;

  final DateTime? lastMessageAt;

  final String? lastMessageUid;

  final String? lastMessageUrl;

  /// [verifiedUserOnly] is true if only the verified users can enter the chat room.
  ///
  /// Note that, [verifiedUserOnly] is not supported at this time.
  final bool verifiedUserOnly;

  /// [urlForVerifiedUserOnly] is true if only the verified users can sent the
  /// url (or include any url in the text).
  ///
  /// Note that, [urlForVerifiedUserOnly] is not supported at this time.
  final bool urlForVerifiedUserOnly;

  /// [uploadForVerifiedUserOnly] is true if only the verified users can sent the
  /// photo.
  ///
  /// Note that, [uploadForVerifiedUserOnly] is not supported at this time.
  final bool uploadForVerifiedUserOnly;

  /// [gender] to filter the chat room by user's gender.
  /// If it's M, then only male can enter the chat room. And if it's F,
  /// only female can enter the chat room.
  ///
  /// Note that, [gender] is not supported at this time.
  final String gender;

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
  final String domain;

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
    this.lastMessageText,
    this.lastMessageAt,
    this.lastMessageUid,
    this.lastMessageUrl,
    this.verifiedUserOnly = false,
    this.urlForVerifiedUserOnly = false,
    this.uploadForVerifiedUserOnly = false,
    required this.gender,
    required this.domain,
  });

  factory ChatRoom.fromSnapshot(DocumentSnapshot doc) {
    dog("doc: ${doc.data()}");
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
      lastMessageText: json[field.lastMessageText],
      lastMessageAt: json[field.lastMessageAt] is Timestamp
          ? (json[field.lastMessageAt] as Timestamp).toDate()
          : DateTime.now(),
      lastMessageUid: json[field.lastMessageUid],
      lastMessageUrl: json[field.lastMessageUrl],
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
      field.lastMessageText: lastMessageText,
      field.lastMessageAt: lastMessageAt,
      field.lastMessageUid: lastMessageUid,
      field.lastMessageUrl: lastMessageUrl,
      field.verifiedUserOnly: verifiedUserOnly,
      field.urlForVerifiedUserOnly: urlForVerifiedUserOnly,
      field.uploadForVerifiedUserOnly: uploadForVerifiedUserOnly,
      field.gender: gender,
      field.domain: domain,
    };
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
      field.masterUsers: [my.uid],
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
      invitedUsers: [otherUid],
      users: [my.uid],
      masterUsers: [my.uid],
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
        field.invitedUsers: FieldValue.arrayRemove([my.uid]),
        field.users: {
          my.uid: {
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
        field.rejectedUsers: FieldValue.arrayRemove([my.uid]),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> rejectInvitation() async {
    await ref.update({
      field.invitedUsers: FieldValue.arrayRemove([my.uid]),
      field.rejectedUsers: FieldValue.arrayUnion([my.uid]),
    });
  }

  /// This only subtracts about 50 years in time. Using subtraction
  /// will help to preserve order after reading the message.
  /// There is a minimum limit for Timestamp for Firestore, that is why,
  /// we can only do a subtraction of about 50 years.
  Timestamp _negatedOrder(DateTime order) =>
      Timestamp.fromDate(order.subtract(const Duration(days: 19000)));

  /// [updateUnreadUsers] is used to update all unread data for all
  /// users inside the chat room.
  Future<void> updateUnreadUsers({
    String? lastMessageText,
    String? lastMessageUrl,
  }) async {
    final serverTimestamp = FieldValue.serverTimestamp();
    final updateUserData = users.map(
      (uid, value) {
        if (uid == my.uid) {
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
      if (lastMessageText != null) field.lastMessageText: lastMessageText,
      field.lastMessageAt: FieldValue.serverTimestamp(),
      field.lastMessageUid: my.uid,
      if (lastMessageUrl != null) field.lastMessageUrl: lastMessageUrl,
      field.users: {
        ...updateUserData,
      }
    }, SetOptions(merge: true));
  }

  /// [read] is used to set as read by the current user.
  /// It means, turning newMessageCounter into zero
  /// and updating the order
  Future<void> read() async {
    if (!userUids.contains(my.uid)) return;
    if (users[my.uid]!.newMessageCounter == 0) return;
    final myReadOrder = users[my.uid]!.timeOrder;
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
}
