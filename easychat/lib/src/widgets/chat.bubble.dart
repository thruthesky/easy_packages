import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.uid == my.uid ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserDoc(
              uid: message.uid!,
              cacheOnly: false,
              builder: (user) {
                if (user == null) {
                  return const CircularProgressIndicator();
                }
                return UserAvatar(user: user);
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: message.uid == my.uid
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: message.uid == my.uid
                      ? const Radius.circular(12)
                      : Radius.zero,
                  bottomRight: message.uid == my.uid
                      ? Radius.zero
                      : const Radius.circular(12),
                ),
              ),
              child: Text(message.text!),
            ),
          ],
        ),
      ),
    );
  }
}
