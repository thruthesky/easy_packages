import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/widgets/task.doc.dart';
import 'package:flutter/material.dart';
import 'package:easy_comment/easy_comment.dart';

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
    return TaskDoc(
      task: widget.task,
      sync: true,
      builder: (task) => Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User ID: ${task.creator}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Project: ${task.project}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Title: ${task.title}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Description: ${task.description}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Created At: ${task.createdAt}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Updated At: ${task.updatedAt}',
                      style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      // complete button
                      TextButton.icon(
                        onPressed: () async {
                          await task.toggleCompleted(!task.completed);
                        },
                        icon: task.completed ? const Icon(Icons.check) : null,
                        label: Text(task.completed ? 'Completed' : 'Complete'),
                      ),
                      ElevatedButton(
                        onPressed: () => TaskService.instance
                            .showTaskUpdateScreen(context, task),
                        child: const Text('Update Task'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: CommentFakeInputBox(
                onTap: () => CommentService.instance.showCommentEditDialog(
                  context: context,
                  documentReference: task.ref,
                  focusOnContent: true,
                ),
              ),
            ),
            CommentListTreeView(documentReference: task.ref),
          ],
        ),
      ),
    );
  }
}
