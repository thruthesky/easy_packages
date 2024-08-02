import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskListTabMenu extends StatelessWidget {
  const TaskListTabMenu({
    super.key,
    required this.options,
    required this.onTap,
  });

  final TaskListOptions options;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () => onTap('all'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('All'.t),
                TaskCount(menu: 'all', completed: options.completed),
              ],
            )),
        TextButton(
            onPressed: () => onTap('task'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tasks'.t),
                TaskCount(menu: 'task', completed: options.completed),
              ],
            )),
        TextButton(
            onPressed: () => onTap('project'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Projects'.t),
                TaskCount(menu: 'project', completed: options.completed),
              ],
            ))
      ],
    );
  }
}
