import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubbleReply extends StatefulWidget {
  const ChatBubbleReply({super.key, required this.message, this.maxWidth});

  final ChatMessage message;
  final double? maxWidth;

  @override
  State<ChatBubbleReply> createState() => _ChatBubbleReplyState();
}

class _ChatBubbleReplyState extends State<ChatBubbleReply> {
  double maxWidth(BuildContext context) =>
      widget.maxWidth ??
      // 48 is the size of the user avatar
      // Note, it looks better when we have some
      // space in left if it is our own message.
      MediaQuery.of(context).size.width * 0.90 - 48;

  ChatMessage get message => widget.message;

  ChatMessage? replyTo;

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    // Check if this is the correct way.
    // Review because this might be wrong.
    // If multiple people is looking at a reply then
    // the true source was deleted, suddenly these multiple
    // devices will update the chat reply to.
    // But it works.
    replyTo = message.replyTo;
    if (replyTo == null) return;
    // No need to listen if it is deleted
    if (replyTo?.deleted == true) return;
    // Listen to the reply message
    final ref =
        ChatService.instance.messageRef(message.roomId!).child(replyTo!.id);
    subscription = ref.onValue.listen((event) {
      final replySource = ChatMessage.fromSnapshot(event.snapshot);
      if (isDifferentText(replySource.text ?? "", replyTo!.text ?? "") ||
          replySource.url != replyTo!.url ||
          replySource.deleted != replyTo!.deleted) {
        // Updating replyTo, The true source is updated
        replyTo = replySource;
        message.update(replyTo: replyTo);
        if (replyTo!.deleted == true) subscription?.cancel();
        return;
      }
    });
  }

  /// Check if two strings are different until 77th character.
  ///
  /// Reason: Only saving until 77th characters in RTDB for reply to.
  /// So that it will only save a part of text.
  isDifferentText(String text1, String text2) {
    final string1 = text1.length > 77 ? text1.substring(0, 77) : text1;
    final string2 = text2.length > 77 ? text2.substring(0, 77) : text2;
    return string1 != string2;
  }

  @override
  dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (replyTo == null) return const SizedBox.shrink();
    return Opacity(
      opacity: 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyTo?.deleted == true) ...[
            Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                'the message being replied has been deleted'.t,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            )
          ] else
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              constraints: BoxConstraints(
                maxWidth: maxWidth(context),
              ),
              child: Column(
                crossAxisAlignment: message.uid != myUid
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  UserDoc(
                    uid: message.replyTo!.uid!,
                    builder: (user) {
                      if (user == null) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (replyTo?.url != null) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 0, 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    height: 56,
                                    width: 56,
                                    child: CachedNetworkImage(
                                      key: ValueKey("reply_${message.url}"),
                                      fadeInDuration: Duration.zero,
                                      fadeOutDuration: Duration.zero,
                                      fit: BoxFit.cover,
                                      imageUrl: replyTo!.url!,
                                      errorWidget: (context, url, error) {
                                        dog("Error in Image Chat Bubble: $error");
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.error,
                                              color: context.error,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(width: 12),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    12,
                                    12,
                                    12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "replying to user".tr(
                                          args: {
                                            "username":
                                                user.displayName.isNotEmpty
                                                    ? user.displayName
                                                    : user.name
                                          },
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: context.onSurface
                                                  .withAlpha(150),
                                            ),
                                        maxLines: 1,
                                      ),
                                      if (replyTo?.text != null &&
                                          replyTo!.text!.isNotEmpty)
                                        Text(
                                          replyTo!.text!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      else if (replyTo?.url != null &&
                                          replyTo!.url!.isNotEmpty)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.photo,
                                              color: context.onSurface
                                                  .withAlpha(200),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "[${'photo'.t}]",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: context.onSurface
                                                        .withAlpha(150),
                                                  ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
