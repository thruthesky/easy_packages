import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  String title = 'Tasks I Created';
  TaskQueryOptions queryOptions = TaskQueryOptions.myCreates();

  final Map<String, TaskQueryOptions> dropDownItems = {
    'Tasks I Created': TaskQueryOptions.myCreates(),
    'Tasks Assigned to Me': TaskQueryOptions.assignedToMe(),
    'Tasks I Created and Assigned to Me':
        TaskQueryOptions.myCreatesAndAssignedToMe(),
    'Tasks I Created and Assigned to Others':
        TaskQueryOptions.myAssignsToOthers(),
    'Tasks I Created but Unassigned Yet':
        TaskQueryOptions.myCreatesButUnassigned(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          items: dropDownItems.keys.toList().map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            );
          }).toList(),
          value: title,
          onChanged: (value) {
            setState(() {
              title = value!;
              queryOptions = dropDownItems[value]!;
            });
          },
          selectedItemBuilder: (context) {
            return dropDownItems.keys.toList().map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: SizedBox(
                  width: 240,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: TaskListView(
          queryOptions: queryOptions,
        ),
      ),
    );
  }
}
