import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatService {
  static ChatService? _instance;
  static ChatService get instance => _instance ??= ChatService._();

  ChatService._();

  bool initialized = false;

  Widget Function()? chatRoomListScreen;
  Widget Function()? chatRoomEditScreen;

  init({
    String? collectionName,
    bool enableAnonymousSignIn = false,
    Widget Function()? chatRoomListScreen,
    Widget Function()? chatRoomEditScreen,
  }) {
    UserService.instance.init();
    if (initialized) {
      dog('UserService is already initialized; It will not initialize again.');
      return;
    }
    initialized = true;

    this.chatRoomListScreen = chatRoomListScreen ?? this.chatRoomListScreen;
    this.chatRoomEditScreen = chatRoomEditScreen ?? this.chatRoomEditScreen;
  }

  CollectionReference get col =>
      FirebaseFirestore.instance.collection('chat-rooms');

  showChatRoomListScreen(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) =>
          chatRoomListScreen?.call() ?? const ChatRoomListScreen(),
    );
  }

  /// Show the chat room edit screen. It's for borth create and update.
  showChatRoomEditScreen(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) =>
          chatRoomEditScreen?.call() ?? const ChatRoomEditScreen(),
    );
  }
}
