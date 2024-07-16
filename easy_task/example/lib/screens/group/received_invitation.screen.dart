import 'package:easy_task/easy_task.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReceivedInvitationScreen extends StatelessWidget {
  const ReceivedInvitationScreen({super.key});

  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
      ),
      body: TaskUserGroupListView(
        queryOptions: TaskUserGroupQueryOptions.invitedMe(),
        itemBuilder: (group, index) {
          return ListTile(
            title: Text(
              group.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await group.accept();
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, a1, a2) =>
                          TaskUserGroupDetailScreen(
                              group: group,
                              onInviteUids: (context) async {
                                return await showGeneralDialog<List<String>?>(
                                  context: context,
                                  pageBuilder: (context, a1, a2) => Scaffold(
                                    appBar: AppBar(
                                      title: const Text("Invite Users"),
                                    ),
                                    body: UserListView(
                                      itemBuilder: (user, index) {
                                        return UserListTile(
                                          user: user,
                                          onTap: () => {
                                            Navigator.of(context)
                                                .pop([user.uid]),
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }),
                    );
                  },
                  child: const Text("Accept"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    group.reject();
                  },
                  child: const Text("Reject"),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
          );
        },
      ),
    );
  }
}
