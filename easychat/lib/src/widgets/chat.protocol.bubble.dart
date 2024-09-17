import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
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
    // Review if we need the if
    // if (protocol == ChatProtocol.join) {
    text = protocol.tr(
      args: {
        'displayName': message.displayName,
      },
    );
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              endIndent: 12,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
                ),
          ),
          const Expanded(
            child: Divider(
              indent: 12,
            ),
          ),
        ],
      ),
    );
  }
}
