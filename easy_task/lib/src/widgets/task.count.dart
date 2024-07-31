import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

/// Task Count model
///
/// Display the no of tasks based on the parameters.
///
/*

- By default, it will display all the tasks under task collection including parent and child tasks, and projects.
- The params below can be combined
  - `all`: If this is set to true, it will only display no of tasks including parent and child tasks. Actually, all the document under the tasks will be returned.
  - `child`: If this is set to true, it will only display the no of child.
  - `project`: If this is set to true, it will display the no of project only. If it is false, only the no of tasks that are not project will be displayed.
  - `completed`: if this is true, only the no of completed tasks are displayed. If it is false, then it will display the no of `not completed` number.
  - `rootLevelTasks`: It displays the no of the root level tasks. It is simpley the combination of `project`: false and `child`: false.



*/
class TaskCount extends StatelessWidget {
  const TaskCount({
    super.key,
    required this.menu,
    this.completed = false,
  });

  final String menu;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AggregateQuerySnapshot>(
      stream: TaskFilter.filter(menu: menu, completed: completed)
          .count()
          .get()
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        }

        return Text(
          '(${snapshot.data!.count})',
        );
      },
    );
  }
}
