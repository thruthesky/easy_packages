import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/widgets/chat.open.room.list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

/// Open chat room list view
class ChatOpenRoomListScreen extends StatelessWidget {
  const ChatOpenRoomListScreen({
    super.key,
    this.itemBuilder,
    this.emptyBuilder,
    this.separatorBuilder,
  });

  final Widget Function(BuildContext context, ChatRoom room, int index)?
      itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('open chat'.t),
      ),
      body: FirebaseDatabaseQueryBuilder(
        query: FirebaseDatabase.instance
            .ref()
            .child('chat/rooms')
            .orderByChild("open")
            // TODO field for open chat room to order properly
            // Open at?
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
            separatorBuilder: (context, index) =>
                separatorBuilder?.call(context, index) ?? const Divider(),
            itemBuilder: (context, index) {
              if (index + 1 == snapshot.docs.length && snapshot.hasMore) {
                snapshot.fetchMore();
              }

              // TODO return the room tile
              final room = ChatRoom.fromSnapshot(snapshot.docs[index]);
              return itemBuilder?.call(context, room, index) ??
                  ChatOpenRoomListTile(
                    room: room,
                  );

              // ChatJoin join = ChatJoin.fromSnapshot(snapshot.docs[index]);
              // return itemBuilder?.call(context, join, index) ??
              //     ChatRoomListTile(
              //       join: join,
              //     );
            },
          );
        },
      ),
    );
  }
}
