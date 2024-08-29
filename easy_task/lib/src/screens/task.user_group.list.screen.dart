import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/task.user_group.dart';
import 'package:easy_task/src/widgets/task_user_group/task.user_group.list_tile.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
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
              TaskService.instance.showUserGroupCreateScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                TaskService.instance.showUserGroupInviteListScreen(context);
              },
              icon: const Icon(Icons.list_alt_sharp)),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: FirestoreListView(
        query: TaskUserGroup.col.where(
          'users',
          arrayContains: TaskService.instance.currentUser!.uid,
        ),
        itemBuilder: (_, snapshot) {
          final userGroup = TaskUserGroup.fromSnapshot(snapshot);
          return TaskUserGroupListTile(userGroup: userGroup);
        },
        emptyBuilder: (context) => Center(
          child: Text('user group list is empty'.t),
        ),
        errorBuilder: (context, error, stackTrace) {
          dog('error: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('An error occurred;\n$error'),
              ],
            ),
          );
        },
      ),
    );
  }
}
