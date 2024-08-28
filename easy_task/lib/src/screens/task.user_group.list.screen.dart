import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class TaskUserGroupListScreen extends StatefulWidget {
  static const String routeName = '/TaskUserGroupList';
  const TaskUserGroupListScreen({super.key});

  @override
  State<TaskUserGroupListScreen> createState() =>
      _TaskUserGroupListScreenState();
}

class _TaskUserGroupListScreenState extends State<TaskUserGroupListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Group List'.t),
          actions: [
            IconButton(
              onPressed: () {
                TaskService.instance.showGroupCreateScreen(context);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: const Column(
          children: [Text('Task Group List')],
        ));
  }
}
