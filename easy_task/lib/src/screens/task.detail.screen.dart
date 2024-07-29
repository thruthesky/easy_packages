import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatefulWidget {
  static const String routeName = '/TaskDetails';
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${widget.task.creator}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Title: ${widget.task.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Description: ${widget.task.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Created At: ${widget.task.createdAt}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Updated At: ${widget.task.updatedAt}',
                style: const TextStyle(fontSize: 16)),
            ElevatedButton(
                onPressed: () => TaskService.instance
                    .showTaskUpdateScreen(context, widget.task),
                child: const Text('Update Task')),
          ],
        ),
      ),
    );
  }
}
