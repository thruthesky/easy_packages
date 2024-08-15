import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
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
  });

  final ChatRoomQuery queryOption;
  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

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
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatRoomInvitationShortList(
                    key: ValueKey("Chat Room Invitation Short List"),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            if (snapshot.docs.isEmpty)
              SliverToBoxAdapter(
                child: emptyBuilder?.call(context) ??
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "chat list is empty".t,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              ),
            SliverList.separated(
              itemCount: snapshot.docs.length,
              separatorBuilder: (context, index) =>
                  separatorBuilder?.call(context, index) ?? const Divider(),
              itemBuilder: (context, index) {
                if (index + 1 == snapshot.docs.length && snapshot.hasMore) {
                  snapshot.fetchMore();
                }

                final room = ChatRoom.fromSnapshot(snapshot.docs[index]);
                if (itemBuilder != null) {
                  return itemBuilder!(context, room, index);
                }
                return ChatRoomListTile(
                  room: room,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
