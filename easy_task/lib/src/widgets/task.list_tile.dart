import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          task.project
              ? const SizedBox(
                  width: 48, height: 48, child: Icon(Icons.diversity_1))
              : Checkbox(
                  value: task.completed,
                  onChanged: (bool? value) async {
                    if (value != null) {
                      await task.toggleCompleted(value);
                    }
                  },
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  task.description,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        if (task.project) {
          TaskService.instance.showProjectDetailScreen(context, task);
        } else {
          TaskService.instance.showTaskDetailScreen(context, task);
        }
      },
    );
  }
}
