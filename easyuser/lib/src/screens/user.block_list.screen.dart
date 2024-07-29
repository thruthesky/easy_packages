import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:easyuser/src/user.service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class UserBlockListScreen extends StatefulWidget {
  static const String routeName = '/BlockList';
  const UserBlockListScreen({super.key});

  @override
  State<UserBlockListScreen> createState() => _UserBlockListScreenState();
}

class _UserBlockListScreenState extends State<UserBlockListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Block List'),
      ),
      body: StreamBuilder(
          stream: i.blockChanges,
          builder: (context, snapshot) {
            final blocks = i.blocks;

            if (blocks.isEmpty) {
              return const Center(
                child: Text('No blocked users'),
              );
            }

            return ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final uid = blocks.keys.elementAt(index);

                print(blocks[uid]['blockedAt']);
                return UserDoc(
                    uid: uid,
                    builder: (user) {
                      if (user == null) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        leading: UserAvatar(user: user),
                        title: DisplayName(user: user),
                        subtitle: Text(
                            'Blocked at: ${(blocks[uid]['blockedAt'].toDate() as DateTime).short}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            i.block(context: context, otherUid: uid);
                          },
                        ),
                      );
                    });
              },
            );
          }),
    );
  }
}
