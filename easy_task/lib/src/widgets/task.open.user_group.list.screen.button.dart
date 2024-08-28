import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskOpenGroupListScreenButton extends StatelessWidget {
  const TaskOpenGroupListScreenButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        TaskService.instance.showGroupListScreen(context);
      },
      icon: const Icon(Icons.groups),
    );
  }
}
