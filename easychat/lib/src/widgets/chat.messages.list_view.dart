import 'package:easy_helpers/easy_helpers.dart';
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
    return FirebaseDatabaseQueryBuilder(
      query: ref.orderByChild("order"),
      builder: (context, snapshot, _) {
        if (snapshot.hasError) {
          dog('Error: ${snapshot.error}');
          return Text('Something went wrong! ${snapshot.error}');
        }
        if (snapshot.isFetching) {
          return const CircularProgressIndicator.adaptive();
        }
        if (snapshot.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet!'),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirebaseDatabaseQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }

            final doc = snapshot.docs[index];

            final message = ChatMessage.fromSnapshot(doc);
            return ChatBubbleLongPressPopupMenu(
              message: message,
              room: room,
              child: itemBuilder?.call(context, message) ??
                  ChatBubble(
                    key: ValueKey("${message.id}_message"),
                    message: message,
                  ),
            );
          },
        );
      },
    );
  }
}
