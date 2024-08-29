import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatInvitationCount extends StatelessWidget {
  const ChatInvitationCount({super.key, required this.builder});

  final Widget Function(int count) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: null,
      builder: (context, snapshot) {
        return FutureBuilder(
            future: ChatService.instance.roomCol
                .where(ChatRoom.field.invitedUsers, arrayContains: myUid)
                .count()
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              final countSnapshot = snapshot.data as AggregateQuerySnapshot;

              return builder(countSnapshot.count ?? 0);
            });
      },
    );
  }
}
