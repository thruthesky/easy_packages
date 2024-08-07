import 'package:cached_network_image/cached_network_image.dart';
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

  ChatMessage? replyTo;

  @override
  void initState() {
    super.initState();
    replyTo = widget.message.replyTo;
    // Listen to the reply message
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.message.uid != myUid
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          UserDoc(
            uid: widget.message.replyTo!.uid!,
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
                "Replying to ${user.displayName}${user.uid == widget.message.uid ? ' (self)' : ''}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              );
            },
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: widget.message.uid != my.uid
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                UserDoc(
                  uid: widget.message.replyTo!.uid!,
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
                            color: widget.message.replyTo!.uid == my.uid
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: maxWidth(context),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.message.replyTo!.url != null) ...[
                                SizedBox(
                                  height: maxWidth(context) / 3,
                                  width: maxWidth(context),
                                  child: CachedNetworkImage(
                                    key:
                                        ValueKey("reply_${widget.message.url}"),
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    fit: BoxFit.cover,
                                    imageUrl: widget.message.replyTo!.url!,
                                  ),
                                ),
                              ],
                              if (widget.message.replyTo!.text != null &&
                                  widget.message.replyTo!.text!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    widget.message.replyTo!.text!,
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
