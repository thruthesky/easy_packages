import 'dart:async';

import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.bubble.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatMessagesListView extends StatefulWidget {
  const ChatMessagesListView({
    super.key,
    required this.room,
    this.itemBuilder,
  });

  final ChatRoom room;
  final Widget Function(BuildContext context, ChatMessage message)? itemBuilder;

  @override
  State<ChatMessagesListView> createState() => _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends State<ChatMessagesListView> {
  StreamSubscription? stream;

  ChatRoom get room => widget.room;
  DatabaseReference get ref => room.messageRef;

  @override
  void initState() {
    super.initState();
    stream = ref.onChildAdded.listen((DatabaseEvent event) => room.read());
  }

  @override
  void dispose() {
    stream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseDatabaseListView(
      query: ref.orderByChild("order"),
      reverse: true,
      itemBuilder: (context, doc) {
        final message = ChatMessage.fromSnapshot(doc);
        return widget.itemBuilder?.call(context, message) ??
            ChatBubble(message: message);
      },
      errorBuilder: (context, error, stackTrace) {
        print("Error: $error");
        return Center(
          child: Text(
            "Error: $error",
          ),
        );
      },
    );
  }
}
