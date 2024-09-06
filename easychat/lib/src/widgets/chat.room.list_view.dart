import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

/// Chat room list view
///
/// It users sliver list to show chat rooms.
///
/// Refer README.md for details.
class ChatRoomListView extends StatelessWidget {
  const ChatRoomListView({
    super.key,
    this.single,
    this.group,
    this.open,
    this.itemBuilder,
    this.emptyBuilder,
    this.separatorBuilder,
    this.invitationSeparatorBuilder,
    this.invitationItemBuilder,
    this.invitationBottomWidget,
    this.invitationTextPadding,
    this.headerBuilder,
  });

  final bool? single;
  final bool? group;
  final bool? open;

  final Widget Function(BuildContext context, ChatJoin join, int index)?
      itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

  final Widget Function(BuildContext, int)? invitationSeparatorBuilder;

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      invitationItemBuilder;

  final Widget? invitationBottomWidget;
  final EdgeInsetsGeometry? invitationTextPadding;

  final Widget Function()? headerBuilder;

  Query get query {
    Query query = ChatService.instance.joinsRef.child(myUid!);

    if (single == true) {
      query = query.orderByChild(singleOrder).startAt(false);
    } else if (group == true) {
      query = query.orderByChild(groupOrder).startAt(false);
    } else if (open == true) {
      query = query.orderByChild(openOrder).startAt(false);
    } else {
      query = query.orderByChild("order").startAt(false);
    }

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseDatabaseQueryBuilder(
      query: query,
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
            // TODO: support custom app bar.
            // SliverAppBar(
            //   title: Text('chat'.t),
            //   floating: true,
            //   snap: true,
            //   actions: [
            //     IconButton(
            //       icon: const Icon(Icons.search),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            if (headerBuilder != null)
              SliverToBoxAdapter(
                child: headerBuilder!.call(),
              ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatInvitationPreviewListView(
                    key: const ValueKey("Chat Room Invitation Short List"),
                    limit: 3,
                    bottomWidget: invitationBottomWidget ?? const Divider(),
                    itemBuilder: invitationItemBuilder,
                    separatorBuilder: invitationSeparatorBuilder,
                    padding: invitationTextPadding,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (snapshot.docs.isEmpty)
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
                itemCount: snapshot.docs.length,
                separatorBuilder: (context, index) =>
                    separatorBuilder?.call(context, index) ?? const Divider(),
                itemBuilder: (context, index) {
                  if (index + 1 == snapshot.docs.length && snapshot.hasMore) {
                    snapshot.fetchMore();
                  }
                  ChatJoin join = ChatJoin.fromSnapshot(snapshot.docs[index]);
                  return itemBuilder?.call(context, join, index) ??
                      ChatJoinListTile(
                        join: join,
                      );
                },
              ),
          ],
        );
      },
    );
  }
}
