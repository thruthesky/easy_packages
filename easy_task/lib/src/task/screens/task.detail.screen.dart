import 'dart:async';
import 'package:easy_task/src/user/user.list.screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskDetailScreen extends StatefulWidget {
  static const String routeName = '/TaskDetail';
  const TaskDetailScreen({
    super.key,
    required this.task,
    this.assignUids,
  });

  final Task task;
  final FutureOr<String?> Function(BuildContext context)? assignUids;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskDetail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Title: ${task.title}"),
            Text("Content: ${task.content}"),
            const SizedBox(height: 24),
            const Text("Assignees:"),
            const SizedBox(height: 12),
            Expanded(
              child: AssignListView(
                queryOptions: AssignQueryOptions(
                  taskId: task.id,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                String? uid;
                if (widget.assignUids != null) {
                  uid = await widget.assignUids!.call(context);
                } else {
                  uid = await showGeneralDialog<String?>(
                    context: context,
                    pageBuilder: (context, a1, a2) {
                      return UserListScreen(
                        onTap: (uid) => Navigator.of(context).pop(uid),
                      );
                    },
                  );
                }
                if (uid == null) return;
                await Assign.create(
                  uid: uid,
                  taskId: task.id,
                );
                if (!mounted) return;
                setState(() {
                  task.assignTo.add(uid!);
                });
                return;
              },
              child: const Text('ASSIGN +'),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                final updatedTask = await showGeneralDialog<Task?>(
                  context: context,
                  pageBuilder: (context, a1, a2) =>
                      TaskUpdateScreen(task: task),
                );
                if (updatedTask == null) return;
                if (!mounted) return;
                setState(() {
                  task = updatedTask;
                });
              },
              child: const Text('UPDATE'),
            ),
            ElevatedButton(
              onPressed: () async {
                await task.delete();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('DELETE'),
            ),
            const SafeArea(
              child: SizedBox(
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
