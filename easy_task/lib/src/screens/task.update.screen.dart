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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      await widget.task.update(
        title: _titleController.text,
        description: _descriptionController.text,
      );
      Navigator.of(context).pop();
      TaskService.instance.showTaskDetailScreen(context, widget.task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateTask,
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
