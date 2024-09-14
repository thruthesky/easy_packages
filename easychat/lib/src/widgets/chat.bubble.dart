import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_url_preview/easy_url_preview.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.onDelete,
    this.onEdit,
  });

  final ChatMessage message;

  /// Callback when user tapped delete from dropdown
  ///
  /// If onDelete is null, it will do `message.delete()`
  /// when user tapped delete.
  final FutureOr<void> Function()? onDelete;

  /// Callback when user tapped edit from dropdown
  ///
  /// If onEdit is null, it will call
  /// `ChatService.instance.showEditMessageDialog`,
  /// when user tapped edit.
  final FutureOr<void> Function()? onEdit;

  double maxWidth(BuildContext context) =>
      // 48 is the size of the user avatar
      // Note, it looks better when we have some
      // space in left if it is our own message.
      MediaQuery.of(context).size.width * 0.90 - 48;

  double photoHeight(BuildContext context) => MediaQuery.of(context).size.width * 0.56;

  Color replyDividerColor(BuildContext context) => message.uid == myUid
      ? const Color.fromARGB(255, 232, 205, 130)
      : Theme.of(context).colorScheme.outlineVariant;

  static const items = (
    reply: 'reply',
    delete: 'delete',
    edit: 'edit',
    report: 'report',
  );

  List<PopupMenuItem<String>> get menuItems => [
        if (ChatService.instance.replyEnabled == false)
          PopupMenuItem<String>(
            value: items.reply,
            height: 40,
            child: Text(items.reply.t),
          ),
        if (message.uid == myUid && message.deleted == false) ...[
          PopupMenuItem<String>(
            value: items.edit,
            height: 40,
            child: Text(items.edit.t),
          ),
          PopupMenuItem<String>(
            value: items.delete,
            height: 40,
            child: Text(items.delete.t),
          ),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    if (message.isProtocol) {
      return ChatProtocolBubble(message: message);
    }

    dog("message display name: ${message.displayName}");
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: menuItems.isNotEmpty
          ? (details) async {
              if (UserService.instance.blockChanges.value.containsKey(message.uid)) {
                return;
              }
              final value = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  0,
                ),
                items: menuItems,
              );
              if (value == null) return;
              if (!context.mounted) return;
              if (value == items.reply) {
                ChatService.instance.reply.value = message;
                return;
              }
              if (value == items.edit) {
                if (onEdit != null) return await onEdit?.call();
                return await ChatService.instance.showEditMessageDialog(
                  context,
                  message: message,
                );
              }
              if (value == items.delete) {
                if (onDelete != null) return await onDelete?.call();
                return await message.delete();
              }
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        // Usually, if the same person is the previous message,
        // it should be a little more connected but for now,
        // we will set it into 8.
        // margin: const EdgeInsets.symmetric(vertical: 4),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: UserBlocked(
            otherUid: message.uid,
            builder: (blocked) {
              if (blocked) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: context.onSurface.withAlpha(50),
                      ),
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.block,
                        color: context.onSurface.withAlpha(50),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "blocked user".t,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: context.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: maxWidth(context) * 3 / 4,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "this message is comming from a blocked user".t,
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize ?? 8,
                              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: message.uid != myUid ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (message.uid != myUid) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: UserDoc.sync(
                        uid: message.uid,
                        builder: (user) => user == null
                            ? const ChatAvatarLoader()
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () =>
                                    UserService.instance.showPublicProfileScreen(context, user: user),
                                child: UserAvatar(user: user),
                              ),
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
                      crossAxisAlignment:
                          message.uid != myUid ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        if (message.uid != myUid) ...[
                          UserField(
                            key: ValueKey("ChatBubbleDisplayName_${message.id}"),
                            uid: message.uid,
                            initialData: message.displayName.isEmpty ? "..." : message.displayName,
                            field: 'displayName',
                            builder: (v, r) {
                              // TODO need to review this User Field because
                              //      There is a chance of flicker when other user has no display name.
                              if (v == null) {
                                return const Text("...");
                              }
                              if (v is String) {
                                return Text(v.trim().isEmpty ? "..." : v);
                              }
                              return const Text("...");
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (message.deleted) ...[
                          Opacity(
                            opacity: 0.38,
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
                                'this message has been deleted'.t,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                              ),
                            ),
                          )
                        ],
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment:
                              message.uid != myUid ? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: [
                            if (message.uid == myUid) timeText(context),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: message.uid == myUid
                                      ? Colors.amber.shade200
                                      : Theme.of(context).colorScheme.surfaceContainerHigh,
                                  borderRadius: BorderRadius.only(
                                    topLeft: message.uid == myUid ? const Radius.circular(12) : Radius.zero,
                                    topRight:
                                        message.uid == myUid ? Radius.zero : const Radius.circular(12),
                                    bottomLeft: const Radius.circular(12),
                                    bottomRight: const Radius.circular(12),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (message.replyTo != null) ...[
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: replyDividerColor(context),
                                            ),
                                          ),
                                        ),
                                        child: ChatBubbleReply(
                                          message: message,
                                          maxWidth: maxWidth(context),
                                        ),
                                      ),
                                    ],
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        message.replyTo != null ? -1 : 0,
                                      ),
                                      child: Container(
                                        decoration: message.replyTo != null
                                            ? BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: replyDividerColor(context),
                                                  ),
                                                ),
                                              )
                                            : null,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (message.url != null) ...[
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      Theme.of(context).colorScheme.surfaceContainerHighest,
                                                ),
                                                height: photoHeight(context),
                                                width: maxWidth(context),
                                                child: CachedNetworkImage(
                                                  key: ValueKey(message.url),
                                                  fadeInDuration: Duration.zero,
                                                  fadeOutDuration: Duration.zero,
                                                  fit: BoxFit.cover,
                                                  imageUrl: message.url!,
                                                  errorWidget: (context, url, error) {
                                                    dog("Error in Image Chat Bubble: $error");
                                                    return Center(
                                                      child: Icon(
                                                        Icons.error,
                                                        color: context.error,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                            if (message.text.notEmpty)
                                              Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Text(
                                                  message.text!,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (message.uid != myUid) timeText(context),
                          ],
                        ),
                        if (message.previewUrl != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                            child: UrlPreview(
                              previewUrl: message.previewUrl!,
                              title: message.previewTitle,
                              description: message.previewDescription,
                              imageUrl: message.previewImageUrl,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget timeText(BuildContext context) {
    if (message.deleted == false) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: myUid == message.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.isUpdated)
              Text(
                'edited'.t,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            Text(
              DateTime.fromMillisecondsSinceEpoch(message.createdAt).shortDateTime,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
