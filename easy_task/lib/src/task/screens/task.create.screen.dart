import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskCreateScreen extends StatefulWidget {
  static const String routeName = '/TodoCreate';
  const TaskCreateScreen({
    super.key,
    this.group,
  });

  final Group? group;

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Create'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (widget.group != null) ...[
              Text("Group ID: ${widget.group!.id}"),
              Text("Group Name: ${widget.group!.name}"),
            ],
            TextField(
              decoration: const InputDecoration(
                label: Text('TITLE'),
              ),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                label: Text('CONTENT'),
              ),
              controller: contentController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: createTask,
              child: const Text("Create Task"),
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

  createTask() async {
    final createRef = await Task.create(
      title: titleController.text,
      content: contentController.text,
      groupId: widget.group?.id,
    );

    final task = await Task.get(createRef.id);
    if (!mounted) return;
    Navigator.of(context).pop();

    if (task == null) return;

    if (widget.group != null) {
      TaskService.instance.assignGroup(
        taskId: task.id,
        groupId: widget.group!.id,
      );
    }

    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => TaskDetailScreen(
        task: task,
      ),
    );
  }
}
