import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Display the number of new messages in the chat room.
///
/// This widget rebuild when the number of new messages changes.
///
/// Counts the total new messages from `chat/settigns/uid/unread-message-count`
///
/// By default, it will not show (0).
/// Use `builder` parameter or set `ChatService.instance.newMessageBuilder` to show it
/// and for customizations.
///
/// <br />
///
/// ---
///
/// <br />
///
/// ### Order:
/// 1. Returns builder parameter value if it is not null
/// 2. Next, returns ChatService.instance.newMessageBuilder, if it is not null
/// 3. Next, it won't show anything if count is 0.
/// 4. By default, it will show Badge(count)
class ChatAllNewMessageCounter extends StatelessWidget {
  const ChatAllNewMessageCounter({
    super.key,
    this.builder,
  });

  final Widget Function(int newMessages)? builder;

  @override
  Widget build(BuildContext context) {
    return MyDoc(
      builder: (user) {
        if (user == null) return const SizedBox.shrink();
        return Value(
          ref: ChatService.instance.mySettingRef.child('unread-message-count'),
          builder: (value, ref) {
            final allUnreads = Map<String, int>.from((value ?? {}) as Map);
            final int totalCount = allUnreads.values.fold(0, (sum, element) => sum + element);
            if (builder != null) {
              // It's dev choice if they want to show the (0)
              return builder!.call(totalCount);
            }
            if (ChatService.instance.newMessageBuilder != null) {
              // It's dev choice if they want to show the (0)
              return ChatService.instance.newMessageBuilder!.call(totalCount.toString());
            }
            if (totalCount == 0) {
              // By default, if no builders, it doesn't show anything
              return const SizedBox.shrink();
            }
            return Badge(
              label: Text(
                '$totalCount',
              ),
            );
          },
        );
      },
    );
  }
}
