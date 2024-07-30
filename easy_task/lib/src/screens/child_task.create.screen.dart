import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class ChildTaskCreateScreen extends StatefulWidget {
  static const String routeName = '/ChildTaskCreate';
  const ChildTaskCreateScreen({super.key, required this.parentTask});

  final Task parentTask;

  @override
  State<ChildTaskCreateScreen> createState() => _ChildTaskCreateScreenState();
}

class _ChildTaskCreateScreenState extends State<ChildTaskCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
                  parent: widget.parentTask.id,
                );
                final task = await Task.get(ref.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  TaskService.instance.showTaskDetailScreen(context, task!);
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
