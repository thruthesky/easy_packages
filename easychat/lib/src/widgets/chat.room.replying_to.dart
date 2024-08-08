import 'package:cached_network_image/cached_network_image.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomReplyingTo extends StatelessWidget {
  const ChatRoomReplyingTo({
    super.key,
    required this.replyTo,
    this.margin = const EdgeInsets.fromLTRB(12, 0, 12, 8),
    this.onPressClose,
    this.maxWidth,
  });

  final ChatMessage replyTo;
  final EdgeInsetsGeometry margin;
  final Function()? onPressClose;
  final double? maxWidth;

  BorderSide? enabledBorderSide(BuildContext context) =>
      Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide;

  double _maxWidth(BuildContext context) =>
      maxWidth ?? MediaQuery.of(context).size.width * 0.70 - 24;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        border: Theme.of(context).inputDecorationTheme.enabledBorder != null
            ? Border.all(
                color: enabledBorderSide(context)?.color ??
                    const Color(0xFF000000),
                width: enabledBorderSide(context)?.width ?? 1.0,
                style: enabledBorderSide(context)?.style ?? BorderStyle.solid,
              )
            : Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Replying to:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 8),
                    UserDoc(
                        uid: replyTo.uid!,
                        builder: (user) {
                          if (user == null) return const SizedBox.shrink();
                          return Row(
                            children: [
                              UserAvatar(
                                user: user,
                                size: 24,
                                radius: 10,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${user.displayName}${user.uid == myUid ? ' (yourself)' : ''}',
                              ),
                            ],
                          );
                        }),
                  ],
                ),
                const SizedBox(height: 8),
                UserDoc(
                  uid: replyTo.uid!,
                  builder: (user) {
                    if (user == null) return const SizedBox.shrink();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (replyTo.text != null &&
                            replyTo.text!.isNotEmpty) ...[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: replyTo.uid == my.uid
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              // constraints: BoxConstraints(
                              //   minWidth: 0,
                              //   maxWidth: _maxWidth(context),
                              // ),
                              clipBehavior: Clip.hardEdge,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  replyTo.text!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (replyTo.text != null && replyTo.url != null) ...[
                          const SizedBox(width: 8),
                        ],
                        if (replyTo.url != null && replyTo.url!.isNotEmpty) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: replyTo.uid == my.uid
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            height: 42,
                            width: 42,
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: replyTo.url!,
                              fit: BoxFit.cover,
                            ),
                          )
                        ]
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          if (onPressClose != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                onPressed: () {
                  // clearReplyTo();
                  onPressClose?.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}
