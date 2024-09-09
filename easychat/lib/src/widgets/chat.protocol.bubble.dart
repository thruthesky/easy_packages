import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class ChatProtocolBubble extends StatelessWidget {
  const ChatProtocolBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final protocol = message.protocol!;
    String text = protocol.t;
    if (protocol == ChatProtocol.join) {
      text = protocol.tr(
        args: {
          'displayName': message.displayName,
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              thickness: 1,
              endIndent: 16,
            ),
          ),
          Text(
            text,
          ),
          const Expanded(
            child: Divider(
              thickness: 1,
              indent: 12,
            ),
          ),
        ],
      ),
    );
  }
}
