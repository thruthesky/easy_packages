import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/task.user_group.dart';
import 'package:flutter/material.dart';

class TaskUserGroupListTile extends StatelessWidget {
  const TaskUserGroupListTile({super.key, required this.userGroup});

  final TaskUserGroup userGroup;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userGroup.title),
      subtitle: Text(userGroup.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        TaskService.instance.showTaskUserGroupDetailScreen(context, userGroup);
      },
    );
  }
}
