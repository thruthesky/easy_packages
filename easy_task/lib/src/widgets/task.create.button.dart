import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskCreateButton extends StatelessWidget {
  const TaskCreateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        TaskService.instance.showTaskCreateScreen(context);
      },
      icon: const Icon(Icons.add),
    );
  }
}
