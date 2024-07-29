import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(
            onPressed: () {
              TaskService.instance.showTaskCreateScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FirestoreListView(
        query: Task.col
            .where('creator', isEqualTo: TaskService.instance.currentUser!.uid)
            .orderBy('createdAt', descending: true),
        itemBuilder: (context, snapshot) {
          final task = Task.fromSnapshot(snapshot);
          print('toggle: ${task.completed} : ${task.title}');
          return ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (bool? value) async {
                if (value != null) {
                  await task.toggleCompleted(value);
                }
              },
            ),
            title: Text(task.title),
            subtitle: Text(task.description),
            onTap: () =>
                TaskService.instance.showTaskDetailScreen(context, task),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          dog('error: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('An error occurred'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
