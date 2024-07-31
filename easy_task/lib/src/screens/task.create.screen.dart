import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskCreateScreen extends StatefulWidget {
  static const String routeName = '/TaskCreate';
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool project = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxListTile(
              value: project,
              title: Text('Project'.t),
              subtitle: const Text('Is it a project?'),
              onChanged: (v) => setState(() => project = v ?? false),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty) {
                  toast(context: context, message: Text('enter a title'.t));
                  return;
                }
                final ref = await Task.create(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  project: project,
                );
                final task = await Task.get(ref.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  if (task!.project) {
                    TaskService.instance.showProjectDetailScreen(context, task);
                  } else {
                    TaskService.instance.showTaskDetailScreen(context, task);
                  }
                }
              },
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
