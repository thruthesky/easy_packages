import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat Service
///
/// This is the chat service class that will be used to manage the chat rooms.
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

  /// CollectionReference for Chat Room docs
  CollectionReference get roomCol =>
      FirebaseFirestore.instance.collection('chat-rooms');

  /// CollectionReference for Chat Room Meta docs
  CollectionReference roomMetaCol(String roomId) => FirebaseFirestore.instance
      .collection('chat-rooms')
      .doc(roomId)
      .collection('chat-room-meta');

  /// DocumentReference for chat room private settings.
  DocumentReference roomPrivateDoc(String roomId) =>
      roomMetaCol(roomId).doc('private');

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
