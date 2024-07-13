import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/src/chat.service.dart';
import 'package:easyuser/easyuser.dart';

class ChatRoom {
  static CollectionReference col = ChatService.instance.col;

  /// [id] is the chat room id.
  final String id;

  /// [ref] is the docuement reference of the chat room.
  DocumentReference get ref => col.doc(id);

  /// [name] is the chat room name. If it does not exist, it is empty.
  final String name;

  /// [description] is the chat room description. If it does not exist, it is empty.
  final String description;

  /// The icon url of the chat room. optinal.
  final String? iconUrl;

  /// [open] is true if the chat room is open chat
  final bool open;

  /// [users] is the uid list of users who are join the room
  final List<String> users;
  final List<String> masterUsers;
  final List<String> invitedUsers;
  final List<String> blockedUsers;
  final List<String> rejectedUsers;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// [hasPassword] is true if the chat room has password
  ///
  /// Note, this is not implemented yet.
  final bool hasPassword;

  /// [text] is the last message text in the chat room.
  ///
  /// This is nullable to know if the last message has text or not.
  final String? text;

  /// [url] is the last message url in the chat room.
  final String? url;

  /// [urlForVerifiedUserOnly] is true if only the verified users can sent the
  /// url (or include any url in the text).
  final bool urlForVerifiedUserOnly;

  /// [uploadForVerifiedUserOnly] is true if only the verified users can sent the
  /// photo.
  final bool uploadForVerifiedUserOnly;

  /// [gender] to filter the chat room by user's gender.
  /// If it's M, then only male can enter the chat room. And if it's F,
  /// only female can enter the chat room.
  final String? gender;

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
  final String? domain;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    this.open = true,
    this.hasPassword = false,
    required this.users,
    required this.masterUsers,
    this.invitedUsers = const [],
    this.blockedUsers = const [],
    this.rejectedUsers = const [],
    required this.createdAt,
    required this.updatedAt,
    this.text,
    this.url,
    this.urlForVerifiedUserOnly = false,
    this.uploadForVerifiedUserOnly = false,
    this.gender,
    this.domain,
  });

  factory ChatRoom.fromSnapshot(DocumentSnapshot doc) {
    return ChatRoom.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json, String id) {
    return ChatRoom(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'],
      open: json['open'] ?? true,
      hasPassword: json['hasPassword'] ?? false,
      users: List<String>.from(json['users'] ?? []),
      masterUsers: List<String>.from(json['masterUsers'] ?? []),
      invitedUsers: List<String>.from(json['invitedUsers'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      rejectedUsers: List<String>.from(json['rejectedUsers'] ?? []),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      text: json['text'],
      url: json['url'],
      urlForVerifiedUserOnly: json['urlForVerifiedUserOnly'] ?? false,
      uploadForVerifiedUserOnly: json['uploadForVerifiedUserOnly'] ?? false,
      gender: json['gender'],
      domain: json['domain'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'open': open,
      'hasPassword': hasPassword,
      'users': users,
      'masterUsers': masterUsers,
      'invitedUsers': invitedUsers,
      'blockedUsers': blockedUsers,
      'rejectedUsers': rejectedUsers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'text': text,
      'url': url,
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

  static Future<DocumentReference> create() async {
    return await col.add({
      'name': 'New Chat Room',
      'description': 'This is a new chat room.',
      'open': true,
      'hasPassword': false,
      'users': [],
      'masterUsers': [my.uid],
      'invitedUsers': [],
      'blockedUsers': [],
      'rejectedUsers': [],
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'text': null,
      'url': null,
      'urlForVerifiedUserOnly': false,
      'uploadForVerifiedUserOnly': false,
      'gender': null,
      'domain': null,
    });
  }
}
