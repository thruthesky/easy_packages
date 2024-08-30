import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/src/task.user_group.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class TaskUserGroupCreateScreen extends StatefulWidget {
  static const String routeName = '/TaskUserGroupCreate';
  const TaskUserGroupCreateScreen({super.key});

  @override
  State<TaskUserGroupCreateScreen> createState() =>
      _TaskUserGroupCreateScreenState();
}

class _TaskUserGroupCreateScreenState extends State<TaskUserGroupCreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Group Create'.t),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
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
                      toast(context: context, message: Text('input a title'.t));
                      return;
                    }
                    final ref = await TaskUserGroup.create(
                      title: titleController.text,
                      description: descriptionController.text,
                    );
                    final group = TaskUserGroup.get(ref.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      debugPrint(group.toString());
                      // TaskService.instance
                      //     .showTaskGroupDetailScreen(context, group);
                    }
                  },
                  child: Text('Create Task Group'.t),
                ),
              ],
            ),
          ),
        ));
  }
}
