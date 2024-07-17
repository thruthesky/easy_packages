import 'dart:async';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/src/user/user.list.screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskDetailScreen extends StatefulWidget {
  static const String routeName = '/TaskDetail';
  const TaskDetailScreen({
    super.key,
    required this.task,
    this.onAssignUid,
    this.group,
  });

  final Task task;
  final FutureOr<String?> Function(BuildContext context)? onAssignUid;

  final TaskUserGroup? group;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task task;
  TaskUserGroup? group;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    group = widget.group;
    if (widget.task.groupId != null && group == null) _initGroup();
  }

  _initGroup() async {
    if (widget.task.groupId == null || widget.task.groupId!.isEmpty) return;
    final group = await TaskUserGroup.get(widget.task.groupId!);
    if (group == null) throw 'Task has group id but Group not found.';
    setState(() {
      this.group = group;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            onPressed: () async {
              final re = await confirm(
                context: context,
                title: "Task Delete",
                message: "Are you sure you want to delete the task?",
              );
              if (re != true) return;
              await task.delete();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () async {
              final updatedTask = await showGeneralDialog<Task?>(
                context: context,
                pageBuilder: (context, a1, a2) => TaskUpdateScreen(task: task),
              );
              if (updatedTask == null) return;
              if (!mounted) return;
              setState(() {
                task = updatedTask;
              });
            },
            icon: const Icon(Icons.edit),
          ),
          const SafeArea(
            child: SizedBox(
              height: 24,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              task.content,
              style: Theme.of(context).textTheme.titleSmall,
            ),
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
            if (group?.moderatorUsers.contains(myUid) ?? task.creator == myUid)
              ElevatedButton(
                onPressed: () async {
                  String? uid;
                  if (widget.onAssignUid != null) {
                    uid = await widget.onAssignUid!.call(context);
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
                    assignTo: uid,
                    task: task,
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
          ],
        ),
      ),
    );
  }
}
