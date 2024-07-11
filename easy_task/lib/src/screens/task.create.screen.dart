import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskCreateScreen extends StatefulWidget {
  static const String routeName = '/TodoCreate';
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TaskCreateScreen> {
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
        title: const Text('Todo Create'),
      ),
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
    );

    final task = await Task.get(createRef.id);
    if (!mounted) return;
    Navigator.of(context).pop();
    if (task == null) return;
    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => TaskDetailScreen(
        task: task,
      ),
    );
  }
}
