import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';

class ChatRoomReplyingTo extends StatelessWidget {
  const ChatRoomReplyingTo({
    super.key,
    required this.replyTo,
    this.margin = const EdgeInsets.fromLTRB(2, 0, 2, 8),
    this.onPressClose,
    this.maxWidth,
  });

  final ChatMessage replyTo;
  final EdgeInsetsGeometry margin;
  final Function()? onPressClose;
  final double? maxWidth;

  BorderSide? enabledBorderSide(BuildContext context) =>
      Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        border: Theme.of(context).inputDecorationTheme.enabledBorder != null
            ? Border.all(
                color: enabledBorderSide(context)?.color ?? const Color(0xFF000000),
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
                      '${'replying to'.t}:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 8),
                    UserModel(
                      uid: replyTo.uid,
                      builder: (user) {
                        if (user == null) return const SizedBox.shrink();
                        return Row(
                          children: [
                            UserAvatar(
                              photoUrl: user.photoUrl,
                              initials: user.displayName.or(user.uid),
                              size: 24,
                              radius: 10,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user.displayName,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                UserField(
                  uid: replyTo.uid,
                  field: User.field.createdAt,
                  builder: (createdAt) {
                    if (createdAt == null) return const SizedBox.shrink();
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (replyTo.url != null && replyTo.url!.isNotEmpty) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: replyTo.uid == my.uid
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.tertiaryContainer,
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            height: 42,
                            width: 42,
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(
                              imageUrl: replyTo.url!,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                        if (replyTo.text != null && replyTo.url != null) ...[
                          const SizedBox(width: 8),
                        ],
                        if (replyTo.text != null && replyTo.text!.isNotEmpty) ...[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: replyTo.uid == my.uid
                                    ? Colors.amber.shade200
                                    : Theme.of(context).colorScheme.surfaceContainerHigh,
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
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
                      color: Theme.of(context).colorScheme.error, borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                onPressed: () {
                  onPressClose?.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}
