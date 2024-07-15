import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskUpdateScreen extends StatefulWidget {
  const TaskUpdateScreen({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.task.title;
    contentController.text = widget.task.content;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Update")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(label: Text('TITLE')),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(label: Text('CONTENT')),
              controller: contentController,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: updateTask,
              child: const Text("Update Task"),
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

  updateTask() async {
    await widget.task.update(
      title: titleController.text,
      content: contentController.text,
    );
    final updatedTask = await Task.get(widget.task.id);
    if (!mounted) return;
    Navigator.of(context).pop(updatedTask);
  }
}
