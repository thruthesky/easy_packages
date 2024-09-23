import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.open.room.list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Open chat room list view
class ChatOpenRoomListScreen extends StatelessWidget {
  const ChatOpenRoomListScreen({
    super.key,
    this.itemBuilder,
    this.emptyBuilder,
    this.separatorBuilder,
    this.pageSize = 20,
    this.loadingBuilder,
    this.errorBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  });

  final Widget Function(BuildContext context, ChatRoom room, int index)? itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

  final int pageSize;
  final Widget Function()? loadingBuilder;
  final Widget Function(String)? errorBuilder;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('open chat'.t),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showChatRoomEditScreen(
                context,
                defaultOpen: true,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FirebaseDatabaseQueryBuilder(
        query: FirebaseDatabase.instance
            .ref()
            .child('chat/rooms')
            .orderByChild("open")
            // TODO field for open chat room to order properly
            // Open at?
            // Should we Use opened at field?
            // If yes, it must be updated every time master updates the
            // chat room.
            .equalTo(true),
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

          return ListView.separated(
            itemCount: snapshot.docs.length,
            separatorBuilder: (context, index) => separatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            cacheExtent: cacheExtent,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior,
            itemBuilder: (context, index) {
              if (index + 1 == snapshot.docs.length && snapshot.hasMore) {
                snapshot.fetchMore();
              }
              final room = ChatRoom.fromSnapshot(snapshot.docs[index]);
              return itemBuilder?.call(context, room, index) ??
                  ChatOpenRoomListTile(
                    room: room,
                  );
            },
          );
        },
      ),
    );
  }
}
