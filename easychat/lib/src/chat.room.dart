import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/src/chat.service.dart';

class ChatRoom {
  static CollectionReference col = ChatService.instance.col;

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

  ChatRoom({
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
    this.urlForVerifiedUserOnly = false,
    this.uploadForVerifiedUserOnly = false,
    this.gender,
  });
}
