import 'package:easychat/easychat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatMessagesListView extends StatelessWidget {
  const ChatMessagesListView({
    super.key,
    required this.room,
    this.itemBuilder,
  });

  final ChatRoom room;
  final Widget Function(BuildContext context, ChatMessage message)? itemBuilder;

  DatabaseReference get ref => room.messageRef;

  @override
  Widget build(BuildContext context) {
    return FirebaseDatabaseListView(
      query: ref.orderByChild("order"),
      reverse: true,
      itemBuilder: (context, doc) {
        final message = ChatMessage.fromSnapshot(doc);
        return itemBuilder?.call(context, message) ??
            ChatBubble(
              key: ValueKey("${message.id}_message"),
              message: message,
            );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Error: $error");
        return Center(
          child: Text(
            "Error: $error",
          ),
        );
      },
    );
  }
}
