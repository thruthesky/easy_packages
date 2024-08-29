import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/task.user_group.dart';
import 'package:easy_task/src/widgets/task.user_group.doc.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class TaskUserGroupDetailScreen extends StatelessWidget {
  const TaskUserGroupDetailScreen({
    super.key,
    required this.userGroup,
  });

  final TaskUserGroup userGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Group Details'.t),
      ),
      body: TaskUserGroupDoc(
        userGroup: userGroup,
        sync: true,
        builder: (userGroup) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${userGroup.title}"),
                const SizedBox(height: 8),
                Text("Description: ${userGroup.description}"),
                const SizedBox(height: 8),
                Text("Created At: ${userGroup.createdAt}"),
                const SizedBox(height: 8),
                Text("Updated At: ${userGroup.updatedAt}"),
                const SizedBox(height: 8),
                Text("Users: ${userGroup.users.length}"),
                const SizedBox(height: 8),
                Text("Users uid: ${userGroup.users}"),
                const SizedBox(height: 8),
                Text("Invited Users: ${userGroup.invitedUsers.length}"),
                const SizedBox(height: 8),
                Text("Invited uids: ${userGroup.invitedUsers}"),
                const SizedBox(height: 8),
                Text("Reject Users: ${userGroup.rejectedUsers.length}"),
                const SizedBox(height: 8),
                Text("Reject Uid: ${userGroup.rejectedUsers}"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // invite user
                        User? user = await UserService.instance
                            .showUserSearchDialog(context);
                        if (user == null) return;

                        await userGroup.inviteUser(user.uid);
                        if (context.mounted) {
                          toast(
                            context: context,
                            message:
                                Text('Task User was invited successfully'.t),
                          );
                        }
                      },
                      child: const Text('Invite users'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                        onPressed: () => TaskService.instance
                            .showTaskUserGroupEditScreen(context, userGroup),
                        child: Text('Edit task user group'.t)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
