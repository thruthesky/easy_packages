import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatJoinListScreen extends StatelessWidget {
  const ChatJoinListScreen({
    super.key,
    this.single,
    this.group,
    this.open,
  });

  final bool? single;
  final bool? group;
  final bool? open;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //     'chat room list screen title: ${queryOption.name.toLowerCase()}'.t),
        actions: [
          IconButton(
            onPressed: () {
              ChatService.instance.showChatRoomEditScreen(
                context,
                // defaultOpen: queryOption == ChatRoomQuery.open,
              );
            },
            icon: const Icon(Icons.add),
          ),
          // PopupMenuButton(
          //   icon: const Icon(Icons.settings),
          //   onSelected: (q) {
          //     setState(() {
          //       queryOption = q;
          //     });
          //   },
          //   constraints: const BoxConstraints(
          //     maxWidth: 180,
          //   ),
          //   itemBuilder: (BuildContext context) {
          //     return ChatRoomQuery.values
          //         .map(
          //           (q) => PopupMenuItem(
          //             value: q,
          //             child: Text(
          //                 'chat room list screen option: ${q.name.toLowerCase()}'
          //                     .t),
          //           ),
          //         )
          //         .toList();
          //   },
          // ),
        ],
      ),
      body: AuthStateChanges(
        builder: (user) {
          if (user == null || user.isAnonymous) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("must login to chat".t),
                  if (ChatService.instance.loginButtonBuilder != null)
                    ChatService.instance.loginButtonBuilder!(context),
                ],
              ),
            );
          }
          return ChatJoinListView(
            single: single,
            group: group,
            open: open,
            itemBuilder: (context, join, index) {
              return ChatJoinListTile(
                join: join,
              );
            },
          );
        },
      ),
    );
  }
}
