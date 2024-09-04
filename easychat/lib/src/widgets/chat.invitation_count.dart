import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat invitation count builder widget
///
/// If the user didn't signed in, it will build with the value of 0.
///
/// See README.md for details.
class ChatInvitationCount extends StatelessWidget {
  const ChatInvitationCount({super.key, required this.builder});

  final Widget Function(int count) builder;

  @override
  Widget build(BuildContext context) {
    return AuthStateChanges(
      builder: (user) => user == null
          ? builder(0)
          : Value(
              ref: ChatService.instance.invitedUserRef(myUid!),
              builder: (v, r) {
                if (v == null) {
                  return builder(0);
                }
                return builder((v as Map).length);
              },
            ),
    );
  }
}
