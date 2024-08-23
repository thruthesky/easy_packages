import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key, required this.options});

  final TaskListOptions options;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: TaskFilter.query(options),
      itemBuilder: (context, snapshot) {
        final task = Task.fromSnapshot(snapshot);
        return TaskListTile(key: ValueKey(task.id), task: task);
      },
      emptyBuilder: (context) => Center(
        child: Text('task list is empty'.t),
      ),
      errorBuilder: (context, error, stackTrace) {
        dog('error: $error');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('An error occurred;\n$error'),
            ],
          ),
        );
      },
    );
  }
}
