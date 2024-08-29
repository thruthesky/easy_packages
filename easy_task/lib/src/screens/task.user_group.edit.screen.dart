import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/src/task.user_group.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class TaskUserGroupEditScreen extends StatefulWidget {
  const TaskUserGroupEditScreen({
    super.key,
    required this.userGroup,
  });

  final TaskUserGroup userGroup;

  @override
  State<TaskUserGroupEditScreen> createState() =>
      _TaskUserGroupEditScreenState();
}

class _TaskUserGroupEditScreenState extends State<TaskUserGroupEditScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.userGroup.title);
    descriptionController =
        TextEditingController(text: widget.userGroup.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task Group'.t),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Task Title'.t),
                controller: titleController,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Task Description'.t),
                controller: descriptionController,
                minLines: 3,
                maxLines: 8,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) {
                    toast(
                      context: context,
                      message: Text('input a title'.t),
                    );
                    return;
                  }
                  await widget.userGroup.update(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  if (context.mounted) {
                    toast(
                      context: context,
                      message: Text('User group updated message'.t),
                    );
                  }
                },
                child: Text('Update Task Group'.t),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
