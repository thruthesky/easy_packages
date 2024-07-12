import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Assigned to Me'),
      ),
      body: TaskListView(
        queryOptions: TaskQueryOptions(
          assignToContains: myUid!,
        ),
      ),
    );
  }
}
