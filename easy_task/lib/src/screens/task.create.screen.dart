import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
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

  List<String> urls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'.t),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CheckboxListTile(
                value: project,
                title: Text('Project'.t),
                subtitle: Text('Is this a project?'.t),
                onChanged: (v) => setState(() => project = v ?? false),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'.t),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'.t),
                minLines: 3,
                maxLines: 8,
              ),
              const SizedBox(height: 20),
              UploadForm(
                urls: urls,
                onUpload: (url) => {},
                onDelete: (url) => {},
                button: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty) {
                      toast(context: context, message: Text('input a title'.t));
                      return;
                    }
                    final ref = await Task.create(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      project: project,
                      urls: urls,
                    );
                    final task = await Task.get(ref.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      if (task!.project) {
                        TaskService.instance
                            .showProjectDetailScreen(context, task);
                      } else {
                        TaskService.instance
                            .showTaskDetailScreen(context, task);
                      }
                    }
                  },
                  child: Text('Create Task'.t),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
