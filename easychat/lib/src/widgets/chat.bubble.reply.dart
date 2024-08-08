import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubbleReply extends StatefulWidget {
  const ChatBubbleReply({super.key, required this.message});

  final ChatMessage message;

  @override
  State<ChatBubbleReply> createState() => _ChatBubbleReplyState();
}

class _ChatBubbleReplyState extends State<ChatBubbleReply> {
  double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56;

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
        dog("Updating replyTo, The true source is updated");
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
        crossAxisAlignment: message.uid != myUid
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          UserDoc(
            uid: message.replyTo!.uid!,
            builder: (user) {
              if (user == null) {
                return Text(
                  "Replying to",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                );
              }
              return Text(
                "Replying to ${user.displayName}${user.uid == message.uid ? ' (self)' : ''}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              );
            },
          ),
          if (replyTo?.deleted == true) ...[
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
          ] else
            Container(
              width: double.infinity,
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
                          Container(
                            decoration: BoxDecoration(
                              color: message.replyTo!.uid == myUid
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (replyTo?.url != null) ...[
                                  SizedBox(
                                    height: maxWidth(context) / 3,
                                    width: maxWidth(context),
                                    child: CachedNetworkImage(
                                      key: ValueKey("reply_${message.url}"),
                                      fadeInDuration: Duration.zero,
                                      fadeOutDuration: Duration.zero,
                                      fit: BoxFit.cover,
                                      imageUrl: replyTo!.url!,
                                    ),
                                  ),
                                ],
                                if (replyTo?.text != null &&
                                    replyTo!.text!.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      replyTo!.text!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
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
