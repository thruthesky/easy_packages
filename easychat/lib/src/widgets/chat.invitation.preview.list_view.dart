import 'dart:async';

import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Displays a few chat room invitations as a list.
/// Shows See more
///
/// This is different from ChatInvitationListView because this has a
/// `see more` button. Still, it can open the chat invitations screen.
///
class ChatInvitationPreviewListView extends StatefulWidget {
  const ChatInvitationPreviewListView({
    super.key,
    this.limit = 3,
    this.padding,
    this.itemBuilder,
    this.separatorBuilder,
    this.bottomWidget = const Divider(),
  });

  final int limit;

  final EdgeInsetsGeometry? padding;

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget? bottomWidget;

  @override
  State<ChatInvitationPreviewListView> createState() =>
      _ChatInvitationPreviewListViewState();
}

class _ChatInvitationPreviewListViewState
    extends State<ChatInvitationPreviewListView> {
  StreamSubscription? subscription;
  List<String> roomIds = [];

  late int limit;

  @override
  void initState() {
    super.initState();
    limit = widget.limit + 1;
    subscription = ChatService.instance
        .invitedUserRef(myUid!)
        .limitToFirst(limit)
        .onValue
        .listen((event) {
      final invitesTime =
          Map<String, int>.from((event.snapshot.value ?? {}) as Map);
      roomIds = invitesTime.keys.toList();
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (roomIds.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            ChatService.instance.showInviteListScreen(context);
          },
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 4),
                ChatInvitationCount(
                  builder: (int no) =>
                      ChatService.instance.newMessageBuilder?.call("$no") ??
                      Badge(label: Text("$no")),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "message request/invitations".t,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (roomIds.length > 3) ...[
                  Text(
                    'view all invitations'.t,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // Added plus one on the query's limit to know if it has more
          // If it retrieve more than the limit, we only show until the limit.
          //
          // Example:
          //  limit = 3;
          //  retrieving 3 + 1.
          //  if retrieved count is 4, show only 3 (the limit)
          //  if retrieved count is 3 or less, show all results
          itemCount:
              roomIds.length > widget.limit ? widget.limit : roomIds.length,
          separatorBuilder: widget.separatorBuilder ??
              (listViewContext, index) => const SizedBox.shrink(),
          itemBuilder: (listViewContext, index) {
            return ChatRoomDoc(
              ref: ChatService.instance.roomRef(roomIds[index]),
              builder: (room) {
                return widget.itemBuilder?.call(context, room, index) ??
                    ChatInvitationListTile(
                      room: room,
                      onAccept: (room, user) async {
                        await ChatService.instance.showChatRoomScreen(
                          context,
                          room: room,
                          user: user,
                        );
                      },
                    );
              },
            );
          },
        ),
        if (widget.bottomWidget != null) widget.bottomWidget!,
      ],
    );
  }
}
