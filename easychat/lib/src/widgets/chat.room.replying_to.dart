import 'package:cached_network_image/cached_network_image.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomReplyingTo extends StatelessWidget {
  const ChatRoomReplyingTo({
    super.key,
    required this.replyTo,
    this.onPressClose,
  });

  final ChatMessage replyTo;
  final Function()? onPressClose;

  BorderSide? enabledBorderSide(BuildContext context) =>
      Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide;

  double maxWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.56;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
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
                Text(
                  'Replying to:',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                UserDoc(
                  uid: replyTo.uid!,
                  builder: (user) {
                    if (user == null) return const SizedBox.shrink();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: UserAvatar(
                            user: user,
                            size: 36,
                            radius: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${user.displayName}${user.uid == myUid ? ' (yourself)' : ''}',
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: replyTo.uid == my.uid
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.zero,
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
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
                                    if (replyTo.url != null) ...[
                                      SizedBox(
                                        height: maxWidth(context) / 3,
                                        width: maxWidth(context),
                                        child: CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          fit: BoxFit.cover,
                                          imageUrl: replyTo.url!,
                                        ),
                                      ),
                                    ],
                                    if (replyTo.text != null &&
                                        replyTo.text!.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          replyTo.text!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
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
