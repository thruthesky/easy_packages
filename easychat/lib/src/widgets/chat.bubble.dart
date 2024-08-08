import 'package:cached_network_image/cached_network_image.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.uid == my.uid ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.uid != my.uid) ...[
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: UserDoc.sync(
                  uid: message.uid!,
                  builder: (user) {
                    if (user == null) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        width: 48,
                        height: 48,
                        child: const CircularProgressIndicator(),
                      );
                    }
                    return UserAvatar(user: user);
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: message.uid != my.uid
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  if (message.uid != my.uid) ...[
                    UserDoc.sync(
                      uid: message.uid!,
                      builder: (user) {
                        if (user == null) {
                          return const Text("...");
                        }
                        return Text(user.displayName);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (message.deleted) ...[
                    Opacity(
                      opacity: 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "This message has been deleted.",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    )
                  ],
                  if (message.replyTo != null) ...[
                    ChatBubbleReply(message: message),
                    const SizedBox(height: 2),
                  ],
                  Container(
                    decoration: BoxDecoration(
                      color: message.uid == my.uid
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: message.uid == my.uid
                            ? const Radius.circular(12)
                            : Radius.zero,
                        topRight: message.uid == my.uid
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.url != null) ...[
                          SizedBox(
                            height: maxWidth(context),
                            width: maxWidth(context),
                            child: CachedNetworkImage(
                              key: ValueKey(message.url),
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              fit: BoxFit.cover,
                              imageUrl: message.url!,
                            ),
                          ),
                        ],
                        if (message.text != null &&
                            message.text!.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(message.text!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
