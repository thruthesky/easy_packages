import 'dart:developer';

import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/widgets.dart';

class ChatNewMessageCounter extends StatefulWidget {
  const ChatNewMessageCounter({
    super.key,
    required this.builder,
  });

  final Widget Function(int newMessages) builder;

  @override
  State<ChatNewMessageCounter> createState() => _ChatNewMessageCounterState();
}

class _ChatNewMessageCounterState extends State<ChatNewMessageCounter> {
  int initialData = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialData,
      stream: ChatRoomQuery.unread().snapshots().map((snapshot) {
        if (snapshot.size == 0) {
          return 0;
        }
        final docs = snapshot.docs;
        int newMessages = 0;
        for (final doc in docs) {
          final room = ChatRoom.fromSnapshot(doc);
          newMessages += room.users[myUid]?.newMessageCounter ?? 0;
        }
        return newMessages;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return Text(snapshot.error.toString());
        }

        initialData = snapshot.data ?? 0;

        return widget.builder(snapshot.data ?? 0);
      },
    );
  }
}
