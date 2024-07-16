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
                pageBuilder: (context, a1, a2) => TaskUserGroupCreateScreen(
                  onCreate: (context, ref) async {
                    final group = await TaskUserGroup.get(ref.id);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    if (group == null) return;
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (context, a1, a2) {
                        return TaskUserGroupDetailScreen(
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
                                        Navigator.of(context).pop([user.uid]),
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Center(
        child: TaskUserGroupListView(
          queryOptions: TaskUserGroupQueryOptions.involvesMe(),
          itemBuilder: (group, index) {
            return ListTile(
              onTap: () async {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) => TaskUserGroupDetailScreen(
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
                                  Navigator.of(context).pop([user.uid]),
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                    userListTileBuilder: (uid) => UserDoc(
                      uid: uid,
                      builder: (user) => ListTile(
                        leading: user == null
                            ? Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Icon(Icons.person),
                                ),
                              )
                            : UserAvatar(user: user),
                        title: Text(
                          user?.displayName ?? uid,
                        ),
                        subtitle: Text(
                          user?.createdAt.toString() ?? '',
                        ),
                        onTap: () {
                          if (!context.mounted) return;
                          if (user == null) return;
                          showGeneralDialog(
                            context: context,
                            pageBuilder: (_, __, ___) =>
                                UserPublicProfileScreen(user: user),
                          );
                        },
                      ),
                    ),
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
