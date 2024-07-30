// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

/// TaskDoc
///
/// Reads and delivers the Task document either once or in real-time.
///
/// [task] is a Task model object.
///
/// If [sync] is true, it reads the Task document in real-time and rebuilds the widget.
///
///
class TaskDoc extends StatelessWidget {
  const TaskDoc({
    required this.task,
    required this.builder,
    this.sync = false,
    super.key,
  });
  final Task task;
  final Widget Function(Task) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder<Task>(
        initialData: task,
        stream: Task.col
            .doc(task.id)
            .snapshots()
            .map((snapshot) => Task.fromSnapshot(snapshot)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData == false) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return builder(snapshot.data!);
        },
      );
    }

    return FutureBuilder(
      initialData: task,
      future: Task.get(task.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return builder(snapshot.data!);
      },
    );
  }
}
