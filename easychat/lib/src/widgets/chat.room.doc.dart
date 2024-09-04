import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatRoomDoc extends StatelessWidget {
  const ChatRoomDoc({
    super.key,
    required this.ref,
    required this.builder,
  });

  final DatabaseReference ref;
  final Widget Function(ChatRoom room) builder;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: ref,
      builder: (v, r) {
        return builder(
          ChatRoom.fromJson(
            Map<String, dynamic>.from(v),
            ref.key!,
          ),
        );
      },
    );
  }
}
