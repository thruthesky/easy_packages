import 'package:easy_task/easy_task.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskUserGroupListScreen extends StatelessWidget {
  static const routeName = '/group-list';

  const TaskUserGroupListScreen({super.key});

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
                    const TaskUserGroupDetailScreen(),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Center(
        child: TaskGroupListView(
          queryOptions: TaskGroupQueryOptions.involvesMe(),
          itemBuilder: (group, index) {
            return ListTile(
              onTap: () async {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) => TaskUserGroupDetailScreen(
                    group: group,
                    inviteUids: (context) async {
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
                                  Navigator.of(context).pop([user.uid]),
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              title: Text(
                group.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text("${group.users.length} Member(s)"),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        ),
      ),
    );
  }
}
