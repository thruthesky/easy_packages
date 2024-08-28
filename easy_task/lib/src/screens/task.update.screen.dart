import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
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
        title: Text('Update Task'.t),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'.t),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description'.t,
              ),
              minLines: 5,
              maxLines: 10,
            ),
            if (widget.task.parent == null && widget.task.project == false) ...[
              const SizedBox(height: 20),
              CheckboxListTile(
                value: project,
                title: Text('Project'.t),
                onChanged: (v) => setState(() => project = v ?? false),
              ),
            ],
            const SizedBox(height: 20),
            UploadForm(
              urls: widget.task.urls,
              onUpload: (url) => {},
              onDelete: (url) => {},
              button: ElevatedButton(
                onPressed: () async {
                  await widget.task.update(
                    title: titleController.text,
                    description: descriptionController.text,
                    project: project,
                    urls: widget.task.urls,
                  );
                  if (context.mounted) {
                    toast(
                        context: context,
                        message: Text('Task updated message'.t));
                  }
                },
                child: Text('Update Task'.t),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
