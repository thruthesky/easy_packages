import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class ChatMessagesListView extends StatefulWidget {
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

  @override
  State<ChatMessagesListView> createState() => _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends State<ChatMessagesListView> {
  DatabaseReference get ref => widget.room.messageRef;
  final ScrollController controller = ScrollController();

  final Map<String, GlobalKey> keyMap = {};
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseDatabaseQueryBuilder(
      query: ref.orderByChild(ChatMessageField.order),
      builder: (context, snapshot, _) {
        if (snapshot.hasError) {
          dog('Error: ${snapshot.error}');
          return Text('Something went wrong! ${snapshot.error}');
        }
        if (snapshot.isFetching && !snapshot.hasData) {
          return const CircularProgressIndicator.adaptive();
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
          controller: controller,
          padding: widget.padding,
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
            final key = keyMap[message.id] ??= GlobalKey();
            return ChatBubbleLongPressPopupMenu(
              message: message,
              room: widget.room,
              child: widget.itemBuilder?.call(context, message) ??
                  ChatBubble(
                    key: key,
                    message: message,
                    onTapReplyTo: (ChatMessage replyTo) {
                      dog("Tapped ReplyTo: ${replyTo.id}");
                      scrollToMessage(replyTo.id);
                    },
                  ),
            );
          },
        );
      },
    );
  }

  void scrollToMessage(String messageId) {
    final key = keyMap[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
