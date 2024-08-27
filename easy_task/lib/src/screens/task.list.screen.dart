import 'package:easy_locale/easy_locale.dart';
import 'package:easy_task/easy_task.dart';
import 'package:flutter/material.dart';

/// Task list screen
///
/// All menu will display all the projects and root level tasks.
///
/// Task menu will display only root level tasks.
///
/// Project menu will display only projects.
///
class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String menu = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'.t),
        actions: const [
          TaskCreateButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TaskListTabMenu(
            onTap: (v) {
              setState(() {
                menu = v;
              });
            },
          ),
        ),
      ),
      body: TaskListView(
        menu: menu,
      ),
    );
  }
}
