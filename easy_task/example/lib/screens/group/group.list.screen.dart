import 'package:easy_task/easy_task.dart';
import 'package:example/screens/group/group.create.screen.dart';
import 'package:example/screens/group/invitation.to_me.list.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupListScreen extends StatelessWidget {
  static const routeName = '/group-list';

  const GroupListScreen({super.key});

  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group List'),
        actions: [
          IconButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, a1, a2) =>
                    const InvitationToMeListScreen(),
              );
            },
            icon: const Icon(Icons.inbox),
          ),
          IconButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, a1, a2) => const GroupCreateScreen(),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Center(
        child: GroupListView(
          queryOptions: GroupQueryOptions(
            membersContain: myUid,
          ),
        ),
      ),
    );
  }
}
