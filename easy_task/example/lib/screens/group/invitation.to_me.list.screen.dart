import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InvitationToMeListScreen extends StatelessWidget {
  const InvitationToMeListScreen({super.key});

  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
      ),
      body: GroupListView(
        queryOptions: GroupQueryOptions(
          invitedUsersContain: myUid!,
        ),
        itemBuilder: (group, index) {
          return ListTile(
            title: Text(group.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await group.accept();
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () {
                    group.reject();
                  },
                  child: const Text("Reject"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
