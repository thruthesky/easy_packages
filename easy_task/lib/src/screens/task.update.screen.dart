import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

class TaskUpdateScreen extends StatefulWidget {
  static const String routeName = '/TaskUpdate';
  const TaskUpdateScreen({super.key, required this.task});

  final Task task;

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  bool project = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);

    project = widget.task.project;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxListTile(
              value: project,
              title: Text('Project'.t),
              onChanged: (v) => setState(() => project = v ?? false),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await widget.task.update(
                  title: titleController.text,
                  description: descriptionController.text,
                  project: project,
                );
                if (context.mounted) {
                  toast(context: context, message: Text('Task Updated'.t));
                }
              },
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}