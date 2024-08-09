import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/chat.locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  double maxWidth(BuildContext context) =>
      // 48 is the size of the user avatar
      // Note, it looks better when we have some
      // space in left if it is our own message.
      MediaQuery.of(context).size.width * 0.90 - 48;

  double photoHeight(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      // Usually, if the same person is the previous message,
      // it should be a little more connected but for now,
      // we will set it into 4.
      // margin: const EdgeInsets.symmetric(vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.uid != myUid
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (message.uid != myUid) ...[
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
              crossAxisAlignment: message.uid != myUid
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                if (message.uid != myUid) ...[
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  )
                ],
                if (message.replyTo != null) ...[
                  ChatBubbleReply(message: message),
                  const SizedBox(height: 4),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: message.uid != myUid
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    if (message.uid == myUid) timeText(context),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: message.uid == myUid
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.only(
                            topLeft: message.uid == myUid
                                ? const Radius.circular(12)
                                : Radius.zero,
                            topRight: message.uid == myUid
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
                                height: photoHeight(context),
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
                    ),
                    if (message.uid != myUid) timeText(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timeText(BuildContext context) {
    if (message.deleted == false) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: myUid == message.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (message.isEdited)
              Text(
                "${'Edited'.t} • ${DateTime.fromMillisecondsSinceEpoch(message.editedAt!).shortDateTime}",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(100),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            Text(
              DateTime.fromMillisecondsSinceEpoch(message.createdAt)
                  .shortDateTime,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
