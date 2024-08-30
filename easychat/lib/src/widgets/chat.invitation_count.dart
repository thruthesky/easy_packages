import 'package:easy_firestore/easy_firestore.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatInvitationCount extends StatelessWidget {
  const ChatInvitationCount({super.key, required this.builder});

  final Widget Function(int count) builder;

  @override
  Widget build(BuildContext context) {
    return Document(
      collectionName: 'chat-settings',
      id: myUid!,
      builder: (model) {
        return builder(model.data['chatInvitationCount'] ?? 0);
      },
    );
  }
}
