import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class ChatRoomListView extends StatelessWidget {
  const ChatRoomListView({
    super.key,
    this.queryOption = ChatRoomQuery.allMine,
    this.itemBuilder,
    this.emptyBuilder,
    this.separatorBuilder,
    this.invitationSeparatorBuilder,
    this.invitationItemBuilder,
    this.invitationBottomWidget,
  });

  final ChatRoomQuery queryOption;
  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

  final Widget Function(BuildContext, int)? invitationSeparatorBuilder;

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      invitationItemBuilder;

  final Widget? invitationBottomWidget;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
      query: queryOption.query,
      builder: (context, snapshot, child) {
        if (snapshot.hasError) {
          dog('chat.room.list_view.dart Something went wrong: ${snapshot.error}');
          return Center(
            child: Text('${'something went wrong'.t}: ${snapshot.error}'),
          );
        }
        if (snapshot.isFetching && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<ChatRoom> chatRooms =
            snapshot.docs.map((doc) => ChatRoom.fromSnapshot(doc)).toList();

        // Either user did not block the other user in single
        // or user was not blocked from the group chat
        final viewableChatRooms = chatRooms.where((room) {
          if (room.blockedUsers.contains(myUid)) return false;
          if (room.group) return true;
          // if single proceed
          Map<String, dynamic> blocks = UserService.instance.blockChanges.value;
          if (blocks.containsKey(getOtherUserUidFromRoomId(room.id) ?? "")) {
            return false;
          }
          return true;
        }).toList();

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatRoomInvitationShortList(
                    key: const ValueKey("Chat Room Invitation Short List"),
                    bottomWidget: invitationBottomWidget ?? const Divider(),
                    itemBuilder: invitationItemBuilder,
                    separatorBuilder: invitationSeparatorBuilder,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (viewableChatRooms.isEmpty)
              SliverToBoxAdapter(
                child: emptyBuilder?.call(context) ??
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 128),
                        child: Text(
                          "chat list is empty".t,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              )
            else
              SliverList.separated(
                itemCount: viewableChatRooms.length,
                separatorBuilder: (context, index) =>
                    separatorBuilder?.call(context, index) ?? const Divider(),
                itemBuilder: (context, index) {
                  if (index + 1 == snapshot.docs.length && snapshot.hasMore) {
                    snapshot.fetchMore();
                  }

                  final room = viewableChatRooms[index];
                  if (itemBuilder != null) {
                    return itemBuilder!(context, room, index);
                  }
                  dog("ChatRoomListTile showLastMessage: ${!room.open}");
                  return ChatRoomListTile(
                    room: room,
                    showLastMessage: !room.open,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
