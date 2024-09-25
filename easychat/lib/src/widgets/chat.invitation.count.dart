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
              ref: ChatService.instance.myInvitationsRef,
              builder: (v, r) {
                if (v == null) return builder(0);
                final blockedUids = UserService.instance.blocks.keys.toList();
                // Filter out the single chat rooms where other user is blocked.
                (v as Map).removeWhere(
                  (roomId, time) {
                    if (!isSingleChatRoom(roomId)) return false;
                    final otherUid = getOtherUserUidFromRoomId(roomId)!;
                    return blockedUids.contains(otherUid);
                  },
                );
                return builder((v).length);
              },
            ),
    );
  }
}
