import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskListTabMenu extends StatelessWidget {
  const TaskListTabMenu({
    super.key,
    required this.onTap,
  });

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
                const TaskCount(menu: 'all'),
              ],
            )),
        TextButton(
            onPressed: () => onTap('task'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tasks'.t),
                const TaskCount(menu: 'task'),
              ],
            )),
        TextButton(
            onPressed: () => onTap('project'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Projects'.t),
                const TaskCount(menu: 'project'),
              ],
            )),
        const Spacer(),
        TextButton(
            onPressed: () => onTap('complete'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Completed'.t),
                const TaskCount(menu: 'complete'),
              ],
            ))
      ],
    );
  }
}
