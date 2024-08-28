import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatMessagesListView extends StatelessWidget {
  const ChatMessagesListView({
    super.key,
    required this.room,
    this.itemBuilder,
    this.padding = const EdgeInsets.only(bottom: 8),
    this.controller,
  });

  final ChatRoom room;
  final Widget Function(BuildContext context, ChatMessage message)? itemBuilder;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;

  DatabaseReference get ref => room.messageRef;

  @override
  Widget build(BuildContext context) {
    return FirebaseDatabaseQueryBuilder(
      query: ref.orderByChild(ChatMessage.field.order),
      builder: (context, snapshot, _) {
        if (snapshot.hasError) {
          dog('Error: ${snapshot.error}');
          return Text('Something went wrong! ${snapshot.error}');
        }
        if (snapshot.isFetching && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.docs.isEmpty) {
          return Center(
            child: Text('no chat message in room yet'.t),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.docs.length,
          // controller: widget.controller,
          padding: padding,
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
            return itemBuilder?.call(context, message) ??
                ChatBubble(
                  key: ValueKey("chatBubble_${message.id}"),
                  message: message,
                );
          },
        );
      },
    );
  }
}
