import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/src/chat.functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easychat/src/chat.service.dart';
import 'package:easyuser/easyuser.dart';

class ChatRoom {
  static CollectionReference col = ChatService.instance.roomCol;

  /// [id] is the chat room id.
  final String id;

  /// [messageRef] is the message reference of the chat room.
  DatabaseReference get messageRef =>
      FirebaseDatabase.instance.ref("/chat-messages/$id");

  /// [docRef] is the docuement reference of the chat room.
  DocumentReference get docRef => col.doc(id);

  /// [name] is the chat room name. If it does not exist, it is empty.
  final String name;

  /// [description] is the chat room description. If it does not exist, it is empty.
  final String description;

  /// The icon url of the chat room. optinal.
  final String? iconUrl;

  /// [users] is the uid list of users who are join the room
  final List<String> users;
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
  final noOfUsers = 0;

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
    return ChatRoom(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'],
      open: json['open'] ?? false, // TODO remove "?? false"
      single: json['single'],
      group: json['group'],
      hasPassword: json['hasPassword'] ?? false, // TODO remove "?? false"
      users: List<String>.from(json['users']),
      masterUsers: List<String>.from(json['masterUsers']),
      invitedUsers: List<String>.from(json['invitedUsers'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      rejectedUsers: List<String>.from(json['rejectedUsers'] ?? []),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastMessageText: json['lastMessageText'],
      lastMessageAt: json['lastMessageAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastMessageUid: json['lastMessageUid'],
      lastMessageUrl: json['lastMessageUrl'],
      verifiedUserOnly:
          json['verifiedUserOnly'] ?? false, // TODO remove "?? false"
      urlForVerifiedUserOnly:
          json['urlForVerifiedUserOnly'] ?? false, // TODO remove "?? false"
      uploadForVerifiedUserOnly:
          json['uploadForVerifiedUserOnly'] ?? false, // TODO remove "?? false"
      gender: json['gender'],
      domain: json['domain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'open': open,
      'single': single,
      'group': group,
      'hasPassword': hasPassword,
      'users': users,
      'masterUsers': masterUsers,
      'invitedUsers': invitedUsers,
      'blockedUsers': blockedUsers,
      'rejectedUsers': rejectedUsers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastMessageText': lastMessageText,
      'lastMessageAt': lastMessageAt,
      'lastMessageUid': lastMessageUid,
      'lastMessageUrl': lastMessageUrl,
      'verifiedUserOnly': verifiedUserOnly,
      'urlForVerifiedUserOnly': urlForVerifiedUserOnly,
      'uploadForVerifiedUserOnly': uploadForVerifiedUserOnly,
      'gender': gender,
      'domain': domain,
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
    final newRoom = {
      'users': [my.uid],
      'masterUsers': [my.uid],
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconUrl != null) 'iconUrl': iconUrl,
      'open': open,
      'single': single,
      'group': group,
      'hasPassword': false,
      // 'hasPassword': password != null, (NOT IMPLEMENTED YET)
      if (invitedUsers != null) 'invitedUsers': invitedUsers,
      if (users != null) 'users': users,
      if (masterUsers != null) 'masterUsers': masterUsers,
      // if (password != null) 'password': password, (NOT IMPLEMENTED YET)
      'verifiedUserOnly': verifiedUserOnly,

      'urlForVerifiedUserOnly': urlForVerifiedUserOnly,

      'uploadForVerifiedUserOnly': uploadForVerifiedUserOnly,
      'gender': gender,
      'domain': domain,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
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
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconUrl != null) 'iconUrl': iconUrl,
      if (open != null) 'open': open,
      if (single != null) 'single': single,
      if (group != null) 'group': group,
      if (lastMessageText != null) 'lastMessageText': lastMessageText,
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt,
      if (lastMessageUid != null) 'lastMessageUid': lastMessageUid,
      if (lastMessageUrl != null) 'lastMessageUrl': lastMessageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await ChatRoom.col.doc(id).update(updateData);
  }

  Future<void> inviteUser(String uid) async {
    await ChatRoom.col.doc(id).update({
      'invitedUsers': FieldValue.arrayUnion([uid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptInvitation() async {
    await ChatRoom.col.doc(id).update({
      'invitedUsers': FieldValue.arrayRemove([my.uid]),
      'users': FieldValue.arrayUnion([my.uid]),
      // In case, the user rejected the invitation
      // but actually wants to accept it, then we should
      // also remove the uid from rejeceted users.
      'rejectedUsers': FieldValue.arrayRemove([my.uid]),
    });
  }

  Future<void> rejectInvitation() async {
    await ChatRoom.col.doc(id).update({
      'invitedUsers': FieldValue.arrayRemove([my.uid]),
      'rejectedUsers': FieldValue.arrayUnion([my.uid]),
    });
  }
}
