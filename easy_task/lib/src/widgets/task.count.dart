import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

/// Task Count model
///
/// Display the no of tasks based on the parameters.
///
/// Aggregate Query cannot be updated in real-time.
class TaskCount extends StatefulWidget {
  const TaskCount({
    super.key,
    required this.menu,
  });

  final String menu;

  @override
  State<TaskCount> createState() => _TaskCountState();
}

/// Task Count State
class _TaskCountState extends State<TaskCount> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TaskService.instance.countRebuildNotifier,
      builder: (context, task, child) {
        return FutureBuilder<int>(
          initialData: count,
          future: TaskFilter.filter(widget.menu).count().get().then(
                (snapshot) => snapshot.count ?? 0,
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.hasData == false) {
              return const CircularProgressIndicator.adaptive();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            count = snapshot.data ?? 0;

            return Text(
              '($count)',
            );
          },
        );
      },
    );
  }
}
